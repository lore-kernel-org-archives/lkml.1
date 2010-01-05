Return-Path: <linux-kernel-owner+w=401wt.eu-S1755541Ab0AEVck@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755541Ab0AEVck (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 16:32:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755512Ab0AEVcf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 16:32:35 -0500
Received: from zcars04e.nortel.com ([47.129.242.56]:52927 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755353Ab0AEVcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 16:32:32 -0500
Message-ID: <4B43AEF6.6050701@nortel.com>
Date: Tue, 05 Jan 2010 15:28:22 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: "David S. Miller" <davem@davemloft.net>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       Neil Horman <nhorman@tuxdriver.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH] net: packet: option to only pass skb protocol
References: <20100105185732.GA30346@redhat.com>
In-Reply-To: <20100105185732.GA30346@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Jan 2010 21:32:28.0047 (UTC) FILETIME=[9451E9F0:01CA8E4E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/05/2010 12:57 PM, Michael S. Tsirkin wrote:
> When sending packets with a packet socket it is often necessary to set
> protocol in msg_name: otherwise the protocol field in the skb will not
> be set correctly.

What about automatically detecting the protocol from the data being sent
to avoid the necessity of specifying it in the first place?

Chris
