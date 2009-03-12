Return-Path: <linux-kernel-owner+w=401wt.eu-S1757197AbZCLRLi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757197AbZCLRLi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 13:11:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756083AbZCLRLb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 13:11:31 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36790 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755574AbZCLRLa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 13:11:30 -0400
Date: Thu, 12 Mar 2009 18:11:21 +0100
From: Michal Schmidt <mschmidt@redhat.com>
To: Jiri Pirko <jpirko@redhat.com>
Cc: linux-kernel@vger.kernel.org, ivecera@redhat.com, jgarzik@pobox.com,
       davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH] 8139cp: allow to set mac address on running device
Message-ID: <20090312181121.79e297a2@brian.englab.brq.redhat.com>
In-Reply-To: <20090312162730.GA20153@psychotron.englab.brq.redhat.com>
References: <20090312162730.GA20153@psychotron.englab.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Mar 2009 17:27:31 +0100
Jiri Pirko <jpirko@redhat.com> wrote:

> +	cpw32_f(MAC0 + 0, le32_to_cpu (*(__le32 *) (dev->dev_addr +
> 0)));
> +	cpw32_f(MAC0 + 4, le32_to_cpu (*(__le32 *) (dev->dev_addr +
> 4)));

You're writing to the card, so using *_to_cpu looks suspicious.

Michal
