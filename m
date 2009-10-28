Return-Path: <linux-kernel-owner+w=401wt.eu-S1757180AbZJ1CnQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757180AbZJ1CnQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 22:43:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756215AbZJ1CnQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 22:43:16 -0400
Received: from mail-gx0-f216.google.com ([209.85.217.216]:45676 "EHLO
	mail-gx0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755995AbZJ1CnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 22:43:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=efsAQHfFl08eDbz8g3d+tckrIp55vGpT6DZRS/DTy2K+3rL2j74Qac9mm2k/P1efk+
         Ep1gk/seX1WmHhgFRIHHnt9Sqk0dp+5QP5xQ0vTClrhEkq/rOjOX9NrZTvAo2EMIM2Uz
         OEkJALt+2YXQPW6w+5+SbxHV7eYyWi38/9cmM=
Message-ID: <4AE7AFC4.3040805@gmail.com>
Date: Tue, 27 Oct 2009 22:43:16 -0400
From: William Allen Simpson <william.allen.simpson@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Andreas Petlund <apetlund@simula.no>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       shemminger@vyatta.com, ilpo.jarvinen@helsinki.fi, davem@davemloft.net
Subject: Re: [PATCH 3/3] net: TCP thin dupack
References: <4AE7207D.8090402@simula.no>
In-Reply-To: <4AE7207D.8090402@simula.no>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Petlund wrote:
> diff --git a/include/linux/tcp.h b/include/linux/tcp.h
> index e64368d..f4a05ff 100644
> --- a/include/linux/tcp.h
> +++ b/include/linux/tcp.h
> @@ -97,6 +97,7 @@ enum {
>  #define TCP_CONGESTION		13	/* Congestion control algorithm */
>  #define TCP_MD5SIG		14	/* TCP MD5 Signature (RFC2385) */
>  #define TCP_THIN_RM_EXPB        15      /* Remove exp. backoff for thin streams*/
> +#define TCP_THIN_DUPACK         16      /* Fast retrans. after 1 dupack */
>  
I've not had the chance to examine the rest, but I've been poking at a
patch series that's used 15 for over a year, so could you try 16 and 17?
