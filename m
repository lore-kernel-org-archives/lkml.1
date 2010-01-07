Return-Path: <linux-kernel-owner+w=401wt.eu-S1753814Ab0AGTVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814Ab0AGTVh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 14:21:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753760Ab0AGTVf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 14:21:35 -0500
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:39231 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752025Ab0AGTVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 14:21:34 -0500
Date: Thu, 7 Jan 2010 20:21:33 +0100
From: Bastian Blank <waldi@debian.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ping Cheng <pingc@wacom.com>
Subject: Re: [PATCH 7/7] Input: wacom - Fail on missing features
Message-ID: <20100107192133.GB15015@wavehammer.waldi.eu.org>
Mail-Followup-To: Bastian Blank <waldi@debian.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	Ping Cheng <pingc@wacom.com>
References: <20100107182553.GA11236@wavehammer.waldi.eu.org> <20100107183009.GA13036@wavehammer.waldi.eu.org> <201001071108.38253.dmitry.torokhov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <201001071108.38253.dmitry.torokhov@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 07, 2010 at 11:08:38AM -0800, Dmitry Torokhov wrote:
> On Thursday 07 January 2010 10:30:09 am Bastian Blank wrote:
> > +	if (!features)
> > +		return -EIO;
> -EINVAL is probably better.

Yes, that is what I was trying to find.

Bastian

-- 
There's a way out of any cage.
		-- Captain Christopher Pike, "The Menagerie" ("The Cage"),
		   stardate unknown.
