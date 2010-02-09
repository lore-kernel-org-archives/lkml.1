Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542Ab0BIGcK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 01:32:10 -0500
Received: from mail-bw0-f219.google.com ([209.85.218.219]:39537 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668Ab0BIGcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 01:32:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=XH56LaK5TfnzSMmbI/Di64rUVZG9gl4pLxq/kgrZwanlw7yKj7IXrgqnK5WIHaXwbx
         tFr7jhqhRtfTwyJu1EtZJwYHBS6YpkRgDZer1HE1F/TvOZNn3CxvIvg8SF1o2qxoHdss
         4FnQEllkjJh07PiotxWPJzEXj7Gc8n/13i6K4=
Subject: Re: [net-next PATCH v2 2/3] net: TCP thin linear timeouts
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Andreas Petlund <apetlund@simula.no>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       Ilpo =?ISO-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>,
       Arnd Hannemann <hannemann@nets.rwth-aachen.de>,
       LKML <linux-kernel@vger.kernel.org>, shemminger@vyatta.com,
       David Miller <davem@davemloft.net>, william.allen.simpson@gmail.com
In-Reply-To: <4B701EE2.1000006@simula.no>
References: <4B701EE2.1000006@simula.no>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Feb 2010 07:31:59 +0100
Message-ID: <1265697119.4236.99.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 08 février 2010 à 15:25 +0100, Andreas Petlund a écrit :
>  
> +	case TCP_THIN_LT:
> +		if (val)
> +			tp->thin_lt = 1;
> +		break;
> +

Why not allowing user to clear thin_lt ?


