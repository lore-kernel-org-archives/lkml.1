Return-Path: <linux-kernel-owner+w=401wt.eu-S1756773AbYE2NGj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756773AbYE2NGj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 09:06:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752613AbYE2NG1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 09:06:27 -0400
Received: from relay.2ka.mipt.ru ([194.85.82.65]:55972 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752316AbYE2NG0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 09:06:26 -0400
Date: Thu, 29 May 2008 17:05:35 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Ingo Molnar <mingo@elte.hu>
Cc: Ilpo J?rvinen <ilpo.jarvinen@helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [bug] stuck localhost TCP connections, v2.6.26-rc3+
Message-ID: <20080529130535.GA10244@2ka.mipt.ru>
References: <20080526115628.GA31316@elte.hu> <20080529084524.GA24892@elte.hu> <Pine.LNX.4.64.0805291332401.16829@wrl-59.cs.helsinki.fi> <20080529112257.GA18130@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080529112257.GA18130@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Thu, May 29, 2008 at 01:22:57PM +0200, Ingo Molnar (mingo@elte.hu) wrote:
> titan:~/tip> netstat -nt
> Active Internet connections (w/o servers)
> Proto Recv-Q Send-Q Local Address               Foreign Address             
> State
> tcp        0      0 10.0.1.14:22                10.0.1.16:58062  ESTABLISHED
> tcp        0      0 10.0.1.14:22                10.0.1.16:60109  ESTABLISHED
> tcp        0  86368 10.0.1.14:43914             10.0.1.16:3632   ESTABLISHED

Are namespaces enabled? It is pretty non-trivial to make established
socket without process from userspace :)

-- 
	Evgeniy Polyakov
