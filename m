Return-Path: <linux-kernel-owner+w=401wt.eu-S1763182AbYBVX51@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763182AbYBVX51 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 18:57:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755083AbYBVX5T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 18:57:19 -0500
Received: from gv-out-0910.google.com ([216.239.58.190]:64924 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753497AbYBVX5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 18:57:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=SBGBHN4x5EKKphVMSsbO8MKBK1jqiSN61sdtnqW5BdQfSNEPDMmJ4zVYQO6Lz9YRQD/sqOXKOCXEIRCMpbQxFPPrPikCAJwvop7KNLTEw2dJ2U7OUEFArgK9puKSHGXIkWWHl781KXa/EPaNlunZvjZCg42QDEmSdH22sdL1bh0=
Message-ID: <998d0e4a0802221557s23abba9as6407c6ced1eb036f@mail.gmail.com>
Date: Sat, 23 Feb 2008 00:57:15 +0100
From: "J.C. Pizarro" <jcpiza@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Improved idea, to use NR_CPUS task_migrators for SMPs.
In-Reply-To: <998d0e4a0802221457g5aee11feo1da2f140a02478b8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <998d0e4a0802221457g5aee11feo1da2f140a02478b8@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008/2/22, J.C. Pizarro <jcpiza@gmail.com>, i wrote:
>                                                                      For comprension, unlocking
>  some lockers of the task_migrators and inmediately switching CPU to
>  migrators is similar to quick awakening of migration_thread.

I'm sorry, it's wrong, the correct is in reverse, locking when it wants to enter
and unlocking when it's exited.
