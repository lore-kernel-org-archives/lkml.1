Return-Path: <linux-kernel-owner+w=401wt.eu-S1752690AbYIJJ6n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690AbYIJJ6n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 05:58:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751586AbYIJJ6g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 05:58:36 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:51821 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751489AbYIJJ6f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 05:58:35 -0400
Date: Wed, 10 Sep 2008 12:58:32 +0300
From: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <syrjala@sci.fi>
To: Jarod Wilson <jwilson@redhat.com>
Cc: linux-kernel@vger.kernel.org, Jarod Wilson <jarod@redhat.com>,
       Janne Grunau <j@jannau.net>, Christoph Bartelmus <lirc@bartelmus.de>
Subject: Re: [PATCH 06/18] lirc driver for the ATI USB RF remote receiver
Message-ID: <20080910095832.GA22422@sci.fi>
Mail-Followup-To: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <syrjala@sci.fi>,
	Jarod Wilson <jwilson@redhat.com>, linux-kernel@vger.kernel.org,
	Jarod Wilson <jarod@redhat.com>, Janne Grunau <j@jannau.net>,
	Christoph Bartelmus <lirc@bartelmus.de>
References: <1220933164-10160-1-git-send-email-jwilson@redhat.com> <1220933164-10160-2-git-send-email-jwilson@redhat.com> <1220933164-10160-3-git-send-email-jwilson@redhat.com> <1220933164-10160-4-git-send-email-jwilson@redhat.com> <1220933164-10160-5-git-send-email-jwilson@redhat.com> <1220933164-10160-6-git-send-email-jwilson@redhat.com> <1220933164-10160-7-git-send-email-jwilson@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1220933164-10160-7-git-send-email-jwilson@redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 09, 2008 at 12:05:51AM -0400, Jarod Wilson wrote:
> +config LIRC_ATIUSB
> +	tristate "ATI RF USB Receiver support"
> +	default n
> +	depends on LIRC_DEV
> +	help
> +	  Driver for the ATI USB RF remote receiver
> +

We already have proper input drivers for these devices (ati_remote and
ati_remote2).

-- 
Ville Syrjälä
syrjala@sci.fi
http://www.sci.fi/~syrjala/
