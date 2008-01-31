Return-Path: <linux-kernel-owner+w=401wt.eu-S1759202AbYAaBvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759202AbYAaBvS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 20:51:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753474AbYAaBvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 20:51:08 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:40333 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413AbYAaBvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 20:51:05 -0500
Date: Thu, 31 Jan 2008 02:51:03 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Geraldo Netto <geraldonetto@gmail.com>
cc: linux-kernel@vger.kernel.org,
       Flavio Alberto Lopes Soares <flaviothunder@terra.com.br>
Subject: Re: how to find out which modules are embedded and running in a
 static kernel
In-Reply-To: <faf3083f0801301736t10b6d251rb86b692dcf496868@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0801310249140.13320@fbirervta.pbzchgretzou.qr>
References: <faf3083f0801301736t10b6d251rb86b692dcf496868@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 30 2008 23:36, Geraldo Netto wrote:
>
>Sorry for this newbie question,
>but i would like to know how to find
>out which modules are embedded
>and running in a static kernel
>because we have a kernel which
>we don't know what components(drivers, ...)
>are embedded and also, we don't know
>which of those components are running
>
>please, note it is not a 'moduled' kernel
>is a static kernel and this means that
>neither lsmod nor /proc/modules
>provide the info that we are looking for

ls -l /sys/module

This lists every feature that is either loaded as a module or has at 
least one module parameter defined.
