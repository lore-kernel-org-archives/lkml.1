Return-Path: <linux-kernel-owner+w=401wt.eu-S1754034AbZFDXUO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034AbZFDXUO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 19:20:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752523AbZFDXUD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 19:20:03 -0400
Received: from mail.lang.hm ([64.81.33.126]:38507 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752281AbZFDXUC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 19:20:02 -0400
Date: Thu, 4 Jun 2009 16:19:56 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard
To: Alexander Clouter <alex@digriz.org.uk>
cc: linux-kernel@vger.kernel.org
Subject: Re: When does Linux drop UDP packets?
In-Reply-To: <buslf6-j24.ln1@woodchuck.wormnet.eu>
Message-ID: <alpine.DEB.1.10.0906041618200.7953@asgard>
References: <20090604145347.GA27692@miyuki> <buslf6-j24.ln1@woodchuck.wormnet.eu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Jun 2009, Alexander Clouter wrote:

> Philipp Reh <sefi@s-e-f-i.de> wrote:
>>
>> I have the following setting in which a client that resides on the same
>> physical network as a server wants to receive any UDP packet that
>> arrives on any of its interfaces sent by that server.
>>
> Read up about multicasting, it will do what you want, does not depend on
> the IP address of the destination workstation and will also cross
> subnets if you want it to.
>
> It's dead easy to transmit and receive multicast traffic, broadcasting
> network traffic is so 1980's :)

there is only a difference between multicast and broadcast traffic if you 
are spanning subnets.

but the issue here is the rp_filter, and that would also filter out 
multicast packets from sources that you don't have routes to.

David Lang

