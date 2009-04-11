Return-Path: <linux-kernel-owner+w=401wt.eu-S1759157AbZDKTXi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759157AbZDKTXi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 15:23:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759012AbZDKTX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 15:23:28 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:47798 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759007AbZDKTX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 15:23:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=DnowQqin7y/tJ2aTguTbrPX0yxGmXeyaXllfK/FL6rhZUFpzcIwn8vc+VM6mkSdMgI
         XSnYKClGIOFBuOjr84hIZPQoJRT7b+vV6lbP8USJKSMP/K2aiabNvvUD1cgvuMtniI4n
         KuP0kCN92LSkpXfIto8SHeQCdstoMxpnyzXvM=
Message-ID: <49E0EE42.3030401@gmail.com>
Date: Sat, 11 Apr 2009 21:23:46 +0200
From: Niel Lambrechts <niel.lambrechts@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090310)
MIME-Version: 1.0
To: "linux >> \"linux.kernel\"" <linux-kernel@vger.kernel.org>
Subject: Re: [2.6.29-git12 iwl3945] wlan0: beacon loss from AP 00:19:5b:e7:a2:f8
 -   sending probe request
References: <cnwGq-5KO-9@gated-at.bofh.it>
In-Reply-To: <cnwGq-5KO-9@gated-at.bofh.it>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/05/2009 11:20 AM, Maciej Rutecki wrote:
> Wireless card:
> 08:00.0 Network controller: Intel Corporation PRO/Wireless 3945ABG
> [Golan] Network Connection (rev 02)
> 
> I have compiled 2.6.29-git12. Comparing to 2.6.29 (stable) I have
> message in dmesg:
> 
> wlan0: beacon loss from AP 00:19:5b:e7:a2:f8 - sending probe request

Same thing here, but my link is not stable, this is using iwlagn on
Intel Wireless WiFi Link 5300AGN REV=0x24. No such issues on 2.6.28 or
2.6.29:

wlan0 direct probe responded
wlan0: authenticate with AP 00:1d:92:1d:1e:8e
wlan0: authenticated
wlan0: associate with AP 00:1d:92:1d:1e:8e
wlan0: RX ReassocResp from 00:1d:92:1d:1e:8e (capab=0x411 status=0 aid=1)
wlan0: associated
wlan0: deauthenticated (Reason: 1)
wlan0: direct probe to AP 00:1d:92:1d:1e:8e try 1
wlan0 direct probe responded
wlan0: authenticate with AP 00:1d:92:1d:1e:8e
wlan0: authenticated
wlan0: associate with AP 00:1d:92:1d:1e:8e
wlan0: RX ReassocResp from 00:1d:92:1d:1e:8e (capab=0x411 status=0 aid=1)
wlan0: associated
wlan0: disassociating by local choice (reason=3)
wlan0: authenticate with AP 00:1d:92:1d:1e:8e
wlan0: authenticated
wlan0: associate with AP 00:1d:92:1d:1e:8e
wlan0: RX AssocResp from 00:1d:92:1d:1e:8e (capab=0x411 status=0 aid=1)
wlan0: associated
wlan0: beacon loss from AP 00:1d:92:1d:1e:8e - sending probe request
wlan0: beacon loss from AP 00:1d:92:1d:1e:8e - sending probe request
wlan0: beacon loss from AP 00:1d:92:1d:1e:8e - sending probe request
wlan0: beacon loss from AP 00:1d:92:1d:1e:8e - sending probe request
wlan0: beacon loss from AP 00:1d:92:1d:1e:8e - sending probe request
wlan0: beacon loss from AP 00:1d:92:1d:1e:8e - sending probe request

Niel
-- 
