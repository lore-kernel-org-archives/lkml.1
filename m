Return-Path: <linux-kernel-owner+w=401wt.eu-S1756347AbYB1HXw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756347AbYB1HXw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 02:23:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752567AbYB1HXo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 02:23:44 -0500
Received: from mx1.redhat.com ([66.187.233.31]:48143 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750911AbYB1HXo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 02:23:44 -0500
Message-ID: <47C6617D.1030700@redhat.com>
Date: Thu, 28 Feb 2008 02:23:41 -0500
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: drago01 <drago01@gmail.com>
CC: kernel list <linux-kernel@vger.kernel.org>
Subject: Re: Reexport init_mm ?
References: <f6ca9fed0802270029l231c6050sefd90ec2997eda37@mail.gmail.com>
In-Reply-To: <f6ca9fed0802270029l231c6050sefd90ec2997eda37@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drago01 wrote:
> init_mm is no longer exported in 2.6.25, because there are no in tree
> modules that use it.
> But the closed sources nvidia drivers are using it.
> Is it possible to reexport this symbol to let the driver work with this kernel?

The fact that there are no in-tree modules that use init_mm is rather 
compelling evidence that it's not a necessary part of the kernel module 
API.  Nvidia needs to fix their code.  If this is a burden, perhaps they 
should publish their code under a GPLv2-compatible license so we can 
show them how to do it.

	-- Chris
