Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968563Ab0B0QYS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 11:24:18 -0500
Received: from smtp128.sbc.mail.sp1.yahoo.com ([69.147.65.187]:47590 "HELO
	smtp128.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S968550Ab0B0QYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 11:24:16 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=xjWV8rdrLkHyY/zXvZbhbZAzOhpMC878XABHRuw4fIQXSz15sgwnkGifiGZsPeAAEDojXM+CIhhA+WauWwCUa3YZkYM2dZd06d+sswTnU+EDqiiD3mLm9BSJO4rtBdYN0ia7RMAhK9J82KqmW0P6mXnS7l18pZcLS1I1lSAQUsw=  ;
X-Yahoo-SMTP: 2V1ThQ.swBDh24fWwg9PZFuY7TTwFsTuVtXZ.8DKSgQ-
X-YMail-OSG: UxJr._sVM1mLPQR8dpU6oApNkdJRGGK.j3cNpiG5cca1SxrBdx8UVUMSW1NMGie7JAF7JhIAVzNIquuHPnF2joa1ik0P28vaXNrDymJyRcrXE_d1wSqgU0iE49usC3bXYzql_3V7O7OGCtfUHtWh2R5pDTTzHpk_15S.hkH19E.b4EHCCM9LMyFI0o_l2xDtbai_yk7bz.2T.5XK6nsNkLQalygC.ym.QJaev.ATv_ZL58IeoVIMGo5fDKomqpIBcXW.7lvdpdbOchigvrBXbLwjGJfLVqBpIfhVYYs-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH 1/3] gpiolib: add gpio_set_direction()
Date: Sat, 27 Feb 2010 08:24:14 -0800
User-Agent: KMail/1.9.10
Cc: Ben Gardner <gardner.ben@gmail.com>, linux-kernel@vger.kernel.org,
       Andres Salomon <dilinger@collabora.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jani Nikula <ext-jani.1.nikula@nokia.com>
References: <cover.1267225701.git.gardner.ben@gmail.com> <201002262302.18890.david-b@pacbell.net> <20100227102609.GA2994@sirena.org.uk>
In-Reply-To: <20100227102609.GA2994@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <201002270824.14889.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 27 February 2010, Mark Brown wrote:
> >  "none" ... since it's not even a GPIO, why would it show
> >       up through the GPIO subsystem???
> 
> I suspect this is intended to be tristated, which might be useful to add.

That's what "input" means, as a rule:  no output driver
is active with a GPIO configured as "iput".  "Tristate"
is an option that's relevant for outputs ... low, high,
or not-driven.

- Dave


