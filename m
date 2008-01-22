Return-Path: <linux-kernel-owner+w=401wt.eu-S1757275AbYAVVGw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757275AbYAVVGw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 16:06:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752642AbYAVVGo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 16:06:44 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:54626 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751754AbYAVVGo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 16:06:44 -0500
Date: Wed, 23 Jan 2008 00:06:27 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: David Fries <david@fries.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: W1: w1_slave units, standardize 1C or .001C?  Break API
Message-ID: <20080122210627.GA30938@2ka.mipt.ru>
References: <20080121231557.GA4025@spacedout.fries.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080121231557.GA4025@spacedout.fries.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David.

On Mon, Jan 21, 2008 at 05:15:57PM -0600, David Fries (david@fries.net) wrote:
> The ds18b20 one wire temperature sensor conversion routine is
> returning the units in degrees C while the ds1820 (ds18s20) is
> returning it in .001 degrees C.  20C vs 20312C.  Once you know the
> units I'm liking the latter as it gives a higher precision.  Time to
> break user applications so the driver can give the temperature in the
> same units for both sensors.

What about instead of breaking application just add new sysfs file,
which will only return temperature instead of full rom content.
It can be millidegrees Centigrade, another one can be millikelvins :)

Actually it is already posible for applications to decode whatever
precision they like from the rom content displayed, although that can be
not very convenient.

-- 
	Evgeniy Polyakov
