Return-Path: <linux-kernel-owner+w=401wt.eu-S1758449AbXKQOCX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758449AbXKQOCX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 09:02:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752681AbXKQOCQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 09:02:16 -0500
Received: from az33egw01.freescale.net ([192.88.158.102]:58988 "EHLO
	az33egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443AbXKQOCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 09:02:15 -0500
Message-ID: <473EF47E.8090402@freescale.com>
Date: Sat, 17 Nov 2007 08:02:38 -0600
From: Timur Tabi <timur@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (Macintosh; U; PPC Mac OS X Mach-O; en-US; rv:1.8.1.8) Gecko/20071008 SeaMonkey/1.1.5
MIME-Version: 1.0
To: Mikael Pettersson <mikpe@it.uu.se>
CC: gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: Add a private_data pointer to struct device_attribute
References: <200711170115.lAH1F5kZ009153@harpo.it.uu.se>
In-Reply-To: <200711170115.lAH1F5kZ009153@harpo.it.uu.se>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mikael Pettersson wrote:

> A common trick is to embed a generic struct inside a specific one
> containing add-on data fields, and then to map from the generic
> one to the specific one using container_of() in your ops (function
> pointers). This is both faster and less wasteful of memory than
> adding void *private all over the place.
> 
> Any reason that won't work here?

Yes, that will work.  Sorry, I should have thought of that myself, since I've 
used that trick a number of times before.

-- 
Timur Tabi
Linux Kernel Developer @ Freescale
