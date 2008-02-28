Return-Path: <linux-kernel-owner+w=401wt.eu-S1763200AbYB1Tec@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763200AbYB1Tec (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 14:34:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762499AbYB1TeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 14:34:12 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:37183 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763319AbYB1TeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 14:34:10 -0500
X-AuthUser: davidel@xmailserver.org
Date: Thu, 28 Feb 2008 11:34:08 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Michael Kerrisk <mtk.manpages@googlemail.com>
cc: =?X-UNKNOWN?Q?Chris_=22=A5=AF=22_Heath?= <chris@heathens.co.nz>,
       David Schwartz <davids@webmaster.com>, dada1@cosmosbay.com,
       "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
       linux-man@vger.kernel.org
Subject: Re: epoll design problems with common fork/exec patterns
In-Reply-To: <cfd18e0f0802280523p1bdacfc5s274387f8280238c8@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0802281133020.7660@alien.or.mcafeemobile.com>
References: <MDEHLPKNGKAHNMBLJOLKAEHCHNAC.davids@webmaster.com> 
 <Pine.LNX.4.64.0710291147180.3387@alien.or.mcafeemobile.com> 
 <47C42CA7.4030607@gmail.com>  <Pine.LNX.4.64.0802261049040.27243@alien.or.mcafeemobile.com>
  <1204075804.5238.7.camel@linux.heathens.co.nz> 
 <Pine.LNX.4.64.0802271131180.377@alien.or.mcafeemobile.com> 
 <cfd18e0f0802280512q43a457d0sc9a8dc83c51e8e1c@mail.gmail.com>
 <cfd18e0f0802280523p1bdacfc5s274387f8280238c8@mail.gmail.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Feb 2008, Michael Kerrisk wrote:

> Davide,
> 
> with the earlier discussion in this thread in mind, I added a Q0/A0 to
> epoll.7, just make the point about keys clear:
> 
> 
>        Q0  What is the key used to distinguish the file descrip-
>            tors in an epoll set?
> 
>        A0  The key is the combination  of  the  file  descriptor
>            number  and  the open file description (also known as
>            "open file handle", the kernel's internal representa-
>            tion of an open file).
> 
> Does that seem okay?

Looks fine to me! We need to clarify better Q6 WRT fork().



- Davide


