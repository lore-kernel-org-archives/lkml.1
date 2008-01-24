Return-Path: <linux-kernel-owner+w=401wt.eu-S1754954AbYAXMjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754954AbYAXMjU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 07:39:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752237AbYAXMjM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 07:39:12 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:41063 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752137AbYAXMjM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 07:39:12 -0500
Date: Thu, 24 Jan 2008 14:39:09 +0200
From: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <syrjala@sci.fi>
To: David Fries <david@fries.net>
Cc: linux-kernel@vger.kernel.org, Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [PATCH] W1: w1_therm.c standardize units to millidegrees C
Message-ID: <20080124123909.GY30987@sci.fi>
Mail-Followup-To: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <syrjala@sci.fi>,
	David Fries <david@fries.net>, linux-kernel@vger.kernel.org,
	Evgeniy Polyakov <johnpol@2ka.mipt.ru>
References: <20080124020330.GA19155@spacedout.fries.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080124020330.GA19155@spacedout.fries.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 23, 2008 at 08:03:30PM -0600, David Fries wrote:
> Here is the patch to standardize the temperature units to millidegrees
> C for the two sensor conversion routines.  Previously the routines
> were,
> 
> w1_DS18B20_convert_temp degrees C
> w1_DS18S20_convert_temp millidegrees C
> 
> Unfortunately this will break any program using the ds18b20 value as
> it will now be 1000 times bigger.  Fortunately there can't be that
> many users out there, or some of these bugs will have been fixed by
> now, such as the negative C error (see previous patch) that makes me
> think the ds18b20 is the better choice to change because of the
> current bugs.

Why isn't w1_therm presented as a hwmon device?

-- 
Ville Syrjälä
syrjala@sci.fi
http://www.sci.fi/~syrjala/
