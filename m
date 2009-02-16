Return-Path: <linux-kernel-owner+w=401wt.eu-S1756077AbZBPJx0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077AbZBPJx0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 04:53:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752630AbZBPJxP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 04:53:15 -0500
Received: from mu-out-0910.google.com ([209.85.134.187]:17692 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752525AbZBPJxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 04:53:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=x6+Z/rsd+rbkv2rvNXdWoMFjIEm6cQ9lbk37mJsCfQ4lOWE0JJIuonvrgO6sMjN8X0
         URoss/+jWW74zpyykiGoA6qkay56bD30HDHwv+q0QodzxXW8h29Bvp4GlbVVGNfmKlcV
         qM+BCz9M9lUZOCv9g72uoowXXDxd+FjaKWCw8=
Message-ID: <49993785.3090907@gmail.com>
Date: Mon, 16 Feb 2009 10:53:09 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: jie.yang@atheros.com
CC: davem@davemloft.net, jcliburn@gmail.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] atl1c:Atheros L1C Gigabit Ethernet driver
References: <12347653231514-git-send-email-jie.yang@atheros.com>
In-Reply-To: <12347653231514-git-send-email-jie.yang@atheros.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/16/2009 07:22 AM, jie.yang@atheros.com wrote:
> +	adapter->hw.hw_addr = ioremap(pci_resource_start(pdev, 0),
> +			pci_resource_len(pdev, 0));

Just in case, is the space cacheable?
