Return-Path: <linux-kernel-owner+w=401wt.eu-S1761514AbZAHTFt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761514AbZAHTFt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 14:05:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755680AbZAHTFf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 14:05:35 -0500
Received: from wf-out-1314.google.com ([209.85.200.175]:17420 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755614AbZAHTFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 14:05:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=w7h5BU4E4PhVukIaeNZ74mYYG3KMYi9S5EQYQViixWtuMlL1riWui0LdItVYbcBsPK
         28MBKA1Qrmk+ntdwgNyzoNTWukbHat0uf7i4ipPoPHY97/Lax071mrRxzSfVFSJcbPWR
         CuCybYnHHJ6UYByi9a/2Igf71kohfU5f2IjG0=
Message-ID: <8bd0f97a0901081105q1e897254kad9a8533b5845403@mail.gmail.com>
Date: Thu, 8 Jan 2009 14:05:33 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "David Miller" <davem@davemloft.net>
Subject: Re: [PATCH 2/2] netdev: bfin_mac: enable VLAN support in Blackfin MAC driver
Cc: cooloney@kernel.org, jeff@garzik.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, graf.yang@analog.com
In-Reply-To: <8bd0f97a0901081101t6fdfa485rbd7ccc4e47691ddb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1231344879-26069-1-git-send-email-cooloney@kernel.org>
	 <1231344879-26069-3-git-send-email-cooloney@kernel.org>
	 <20090108.105531.176161465.davem@davemloft.net>
	 <8bd0f97a0901081101t6fdfa485rbd7ccc4e47691ddb@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 8, 2009 at 14:01, Mike Frysinger wrote:
> On Thu, Jan 8, 2009 at 13:55, David Miller wrote:
>> We can get VLAN packets received and sent, using AF_PACKET
>> sockets, for example.  The chip should still respect those
>> even if VLAN proper is not being utilized.
>
> any tips on doing that ?

or rather, is there a driver or you two you can point out that is
doing this correctly ?  the ones i looked at seemed to be doing it
like the patch we posted ...
-mike
