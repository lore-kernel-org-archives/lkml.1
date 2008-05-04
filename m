Return-Path: <linux-kernel-owner+w=401wt.eu-S1752124AbYEDOzQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752124AbYEDOzQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 10:55:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751477AbYEDOy4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 10:54:56 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:53367 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452AbYEDOyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 10:54:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=VzVLDilOph3cE5s5IvZ7QDsjchchbRy+TYb+bIxus4D51+bZlGZnhJQaMWEnpq+9oEL3KMcRJ5MdKgmGiVYU4mJ4JgUt7A3mu2Sfcyt9FmMO5Sgt1YT4hmhbRYXdJAILbUwXqIJUugNLsk+2cPc+R/shWXaOjfY+x6j7DIbg3gc=
Message-ID: <481DCE4C.9070805@gmail.com>
Date: Sun, 04 May 2008 16:55:08 +0200
From: Jarek Poplawski <jarkao2@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: Jay Cliburn <jacliburn@bellsouth.net>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Chris Snook <csnook@redhat.com>
Subject: Re: Need help debugging memory corruption
References: <20080503130951.091392ba@osprey.hogchain.net> <481DC731.5090303@gmail.com>
In-Reply-To: <481DC731.5090303@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jarek Poplawski wrote, On 05/04/2008 04:24 PM:
...

> I'm definitely with less experience, so I wonder why it can't be
> a simple race between atl1_clean_rx_ring() and something (maybe even
> pending atl1_intr_rx()) on the other cpu writing skb while kfreeing?


Hmm... atl1_intr_rx() looks impossible, so atl1_alloc_rx_buffers()?

Jarek P. 


