Return-Path: <linux-kernel-owner+w=401wt.eu-S1755159AbXGTEcL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755159AbXGTEcL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 00:32:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750840AbXGTEb5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 00:31:57 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:65197 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826AbXGTEb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 00:31:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=CkQP1+TkYYSZYG3beuwEWcj8UDCmL0bpDcO3aFtk2pW3am6wXcvvZvWHvCOCdEq+42UrokP3NnZ47l5jOOReDt7r4pFJTlWhP35TYUDChB5YCyLKCpsvEL6SYrMLLrRJN9dZ1tFVuJ7NpspsYN3BTt7/0FY9EnNKTs6koSaJMJg=
Message-ID: <7fac565a0707192131t1af0982aq5a75fef2fe014762@mail.gmail.com>
Date: Fri, 20 Jul 2007 06:31:55 +0200
From: "Alexey Eremenko" <al4321@gmail.com>
To: "Rusty Russell" <rusty@rustcorp.com.au>
Subject: Re: [PATCH] Move KVM, paravirt, lguest, VMI and Xen under arch-level Virtualization option
Cc: "lkml - Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andi Kleen" <ak@muc.de>,
       virtualization <virtualization@lists.linux-foundation.org>
In-Reply-To: <1184905342.10380.263.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1184905342.10380.263.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/20/07, Rusty Russell <rusty@rustcorp.com.au> wrote:
> Any objections?
>
> Rusty.
> ===
> Having KVM appear in the middle of "drivers" is kinda strange, and
> having it alone under a menu called "virtualization" doubly so.
>

Hi Rusty !

Very good move, that I have thought about too... I believe that since
we're creating a Virtualization Menu, we should add
OS-level-virtualization there as well  (aka containerization) - the
following things: IPC virtualization (aka IPC namespaces), PID
virtualization, UTS virtualization. Those are 3 basic components that
went mainline into 2.6.19.

Article from OpenVZ:
http://www.linux.com/articles/59150?tid=136&tid=91

P.S. maybe rename those components from "IPC namespaces" to "IPC
virtualization" or even to "IPC containerization" it better reflect
it's internals?

-- 
-Alexey Eremenko "Technologov"
