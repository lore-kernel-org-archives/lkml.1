Return-Path: <linux-kernel-owner+w=401wt.eu-S1753786Ab0AGTVO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753786Ab0AGTVO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 14:21:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753078Ab0AGTVL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 14:21:11 -0500
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:39224 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752180Ab0AGTVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 14:21:10 -0500
Date: Thu, 7 Jan 2010 20:21:05 +0100
From: Bastian Blank <waldi@debian.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ping Cheng <pingc@wacom.com>
Subject: Re: [PATCH 2/7] Input: wacom - Get features from driver info
Message-ID: <20100107192105.GA15015@wavehammer.waldi.eu.org>
Mail-Followup-To: Bastian Blank <waldi@debian.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	Ping Cheng <pingc@wacom.com>
References: <20100107182553.GA11236@wavehammer.waldi.eu.org> <20100107182936.GA12913@wavehammer.waldi.eu.org> <201001071106.31688.dmitry.torokhov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <201001071106.31688.dmitry.torokhov@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 07, 2010 at 11:06:30AM -0800, Dmitry Torokhov wrote:
> On Thursday 07 January 2010 10:29:36 am Bastian Blank wrote:
> > +	struct wacom_features *features = (void *)id->driver_info;
> What is this cast for?

driver_info is an integer.

> > +	if (!features)
> > +		features = get_wacom_feature(id);
> In which cases driver would not have driver_info set up?

At this stage in the patchset, non have. Later the driver defined ids
have, the user defined have not.

Bastian

-- 
Bones: "The man's DEAD, Jim!"
