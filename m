Return-Path: <linux-kernel-owner+w=401wt.eu-S1760275AbXJaQfm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760275AbXJaQfm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 12:35:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754867AbXJaQfe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 12:35:34 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:35489 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753848AbXJaQfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 12:35:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=dBkfxqO0ZPHh0yIMNFSKvnSI3uuqQViJK49AtKpMEQaKb8yYYqI9nRiZgPIVA+rc7w1sRPU69y3cV9wHzzvZJDgr/agTY0OcpeyHjPATSmwUtoj6wyOTYQVo+0ksBRE1+fl9kLIzEVH5VDVVXAh8tjSUzXbWPNeCNakDKMYqBcY=
Message-ID: <d120d5000710310935i13629beahdc01e775e3cf6aa@mail.gmail.com>
Date: Wed, 31 Oct 2007 12:35:31 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: kernel processes - are they really needed?
Cc: Ram <vshrirama@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <p73hckgqoxg.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8bf247760710240637w686f1a2fxdf63a649787eca25@mail.gmail.com>
	 <p73hckgqoxg.fsf@bingen.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/07, Andi Kleen <andi@firstfloor.org> wrote:
>
> My favourite for a ridiculous thread was and is "kpsmoused"
>

Mouse querying can take significant amount of time. Do you really want
all your other events to be delayed just because kernel tries to get
mouse back in order?

Although I probably want to kill it if mouse resync is disabled...

-- 
Dmitry
