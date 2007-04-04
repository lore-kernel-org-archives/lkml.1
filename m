Return-Path: <linux-kernel-owner+w=401wt.eu-S2992714AbXDDHqi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992714AbXDDHqi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 03:46:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992722AbXDDHqi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 03:46:38 -0400
Received: from vulpecula.futurs.inria.fr ([195.83.212.5]:38876 "EHLO
	vulpecula.futurs.inria.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992714AbXDDHqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 03:46:37 -0400
Message-ID: <461357D8.8060608@tremplin-utc.net>
Date: Wed, 04 Apr 2007 09:46:32 +0200
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <Eric.Piel@tremplin-utc.net>
User-Agent: Thunderbird 2.0b2 (X11/20070307)
MIME-Version: 1.0
To: Karl Pickett <karl.pickett@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-input@atrey.karlin.mff.cuni.cz,
       dmitry.torokhov@gmail.com
Subject: Re: [PATCH] Make ati_remote button repeat sensitivity soft-configurable
References: <f9be06770704031734k11ec894fpdf1afe385108aece@mail.gmail.com>
In-Reply-To: <f9be06770704031734k11ec894fpdf1afe385108aece@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

04/04/2007 02:34 AM, Karl Pickett wrote/a écrit:
> The ati_remote driver is a little too sensitive for my wife... if you
> do anything but barely tap the button you can get multiple events
> reported.  We prefer a more conservative no-repeat setting.  This is a
> pretty trivial patch which just makes one hard coded value soft
> configurable and does not change the default.
This default value is set to 300 ms. On my Xserver, the default value is 
660 ms and by default in my distrib it's set to 500 ms. So, indeed, the 
default value of the ati_remote is quite small. Maybe you could increase 
FILTER_MAX to 10 (= 600 ms) in order to have something saner?

That was my two cents :-)
See you,
Eric
