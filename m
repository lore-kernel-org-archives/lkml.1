Return-Path: <linux-kernel-owner+w=401wt.eu-S1752030AbYJROi7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752030AbYJROi7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 10:38:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751399AbYJROis
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 10:38:48 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:53043 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264AbYJROir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 10:38:47 -0400
X-AuthUser: davidel@xmailserver.org
Date: Sat, 18 Oct 2008 07:38:40 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Alexander Beregalov <a.beregalov@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Netdev <netdev@vger.kernel.org>
Subject: Re: 2.6.27-05178-g2e532d6: list_add corruption
In-Reply-To: <a4423d670810172341y5ae5542jea66ead938ba652d@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0810180737100.21525@alien.or.mcafeemobile.com>
References: <a4423d670810171220t4d5602fekcb66e18758149925@mail.gmail.com> 
 <Pine.LNX.4.64.0810171617490.21410@alien.or.mcafeemobile.com>
 <a4423d670810172341y5ae5542jea66ead938ba652d@mail.gmail.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 18 Oct 2008, Alexander Beregalov wrote:

> > This is very likely to be caused by a patch that went in a few days ago.
> > Already posted a fix to Andrew.
> >
> 
> Is it the same problem? 2.6.27-05577-g0cfd810

Hard to be sure, but certainly a double insert can create a similar 
problem. The only way to tell is to get the fix and retry.


- Davide


