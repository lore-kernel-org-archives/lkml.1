Return-Path: <linux-kernel-owner+w=401wt.eu-S965329AbXAYNRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965329AbXAYNRU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 08:17:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965333AbXAYNRT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 08:17:19 -0500
Received: from burp.tkv.asdf.org ([212.16.99.49]:54374 "EHLO moth.iki.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965329AbXAYNRT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 08:17:19 -0500
Date: Thu, 25 Jan 2007 15:17:15 +0200
Message-Id: <200701251317.l0PDHFV7025442@moth.iki.fi>
From: Markku Savela <msa@moth.iki.fi>
To: msa@moth.iki.fi
CC: greg@kroah.com, linux-kernel@vger.kernel.org
In-reply-to: <200701251311.l0PDBFD0025319@moth.iki.fi> (message from Markku
	Savela on Thu, 25 Jan 2007 15:11:15 +0200)
Subject: Re: How to get /dev entry created automaticly for dynamic major number?
References: <200701250735.l0P7Z7aN018630@moth.iki.fi> <20070125082544.GA16300@kroah.com> <200701251311.l0PDBFD0025319@moth.iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oops!

The error exits are not right in foo_init (need to release anything
succesfully created, if later operations fail). Probably need to make
the current foo_exit into foo_cleanup and call it in real foo_exit and
in any errors at foo_init.

But, again thanks for the help. I consider the "case closed" now.

