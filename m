Return-Path: <linux-kernel-owner+w=401wt.eu-S1762278AbYESXDW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762278AbYESXDW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 19:03:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755365AbYESXDO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 19:03:14 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:41676 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753672AbYESXDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 19:03:13 -0400
In-Reply-To: <20080519153249.ea80e683.akpm@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Subject: Re: [2.6.27 patch] the scheduled smbfs removal
X-Mailer: Lotus Notes Release 7.0 HF277 June 21, 2006
Message-ID: <OF86D6B4D3.18C3673E-ON8725744E.007E5B54-8625744E.007EBB19@us.ibm.com>
From: Steven French <sfrench@us.ibm.com>
Date: Mon, 19 May 2008 18:03:10 -0500
X-MIMETrack: Serialize by Router on D03NM123/03/M/IBM(Release 7.0.2FP2HF300 | September
 14, 2007) at 05/19/2008 17:03:11,
	Serialize complete at 05/19/2008 17:03:11
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FYI - last week at connectathon I added one patch relating to backlevel 
support and mapping of open flags on legacy smb open calls (although 
perhaps some longtime smbfs users would not notice since smbfs did not 
have this support either).

The utimes support for backlevel servers is one obvious thing that I have 
not added (but smbfs had some limited support for) but was considring 
adding.


Steve French
Senior Software Engineer
Linux Technology Center - IBM Austin
phone: 512-838-2294
email: sfrench at-sign us dot ibm dot com

Andrew Morton <akpm@linux-foundation.org> wrote on 05/19/2008 05:32:49 PM:

> On Tue, 20 May 2008 00:53:11 +0300
> Adrian Bunk <bunk@kernel.org> wrote:
> 
> > This patch contains the scheduled smbfs removal.
> 
> I don't know how popular this will be right now - quite a few
> people needed to be dragged over to cifs up to a month or two
> ago.
> 
> I'd suggest that we first use CONFIG_BROKEN or
> CONFIG_DIFFICULT_TO_GET_AT and see what the effect of that is.
> 

