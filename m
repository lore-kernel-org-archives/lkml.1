Return-Path: <linux-kernel-owner+w=401wt.eu-S1757580AbZBZQeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757580AbZBZQeS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 11:34:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754944AbZBZQeH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 11:34:07 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:33020 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754809AbZBZQeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 11:34:04 -0500
X-AuthUser: davidel@xmailserver.org
Date: Thu, 26 Feb 2009 08:34:02 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Tony Battersby <tonyb@cybernetics.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Jonathan Corbet <corbet@lwn.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/6] [-mm] epoll: remove unnecessary xchg
In-Reply-To: <49A42E4B.1060100@cybernetics.com>
Message-ID: <alpine.DEB.2.00.0902260833140.31638@alien.or.mcafeemobile.com>
References: <49A42E4B.1060100@cybernetics.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Feb 2009, Tony Battersby wrote:

> xchg in ep_unregister_pollwait() is unnecessary because it is protected
> by either epmutex or ep->mtx (the same protection as ep_remove()).

Acked-by: Davide Libenzi <davidel@xmailserver.org>


- Davide


