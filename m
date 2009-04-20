Return-Path: <linux-kernel-owner+w=401wt.eu-S1752790AbZDTQTx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790AbZDTQTx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 12:19:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751212AbZDTQTo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 12:19:44 -0400
Received: from intcomgrp.com ([216.54.13.120]:43847 "EHLO beta.intcomgrp.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751161AbZDTQTn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 12:19:43 -0400
X-Greylist: delayed 2383 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Apr 2009 12:19:43 EDT
Message-ID: <49EC9709.8070002@support.intcomgrp.com>
Date: Mon, 20 Apr 2009 11:38:49 -0400
From: James Kosin <jkosin@beta.intcomgrp.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: [RFD] voltage/current regulator consumer interface
References: <ct38K-3Fq-11@gated-at.bofh.it>
In-Reply-To: <ct38K-3Fq-11@gated-at.bofh.it>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Rapoport wrote:
> Hi,
> 
> Recently there was a brief discussion on linux-arm-kernel list [1] about
> controlling voltage regulator state in cases when there is no consumer device
> for a particular regulator.
> 
> I have some thoughts but I'd like to know people opinion before I start
> implementation.
> 
> Problem
> -------
> The regulator framework API provides ability to control the state of
> voltage/current regulators from within the kernel. Usually the regulator
> supplies power to a device and device driver or some hooks to the platform code
> from the device driver manipulate the regulator state. However, the regulator
> framework does not have userspace ABI that allows regulator state modifications.
> Lack of this ABI prevents fine-grained control for power consumption of devices
> such as GPS trancievers and GSM modems. Moreover, in SoC based systems it is
> possible to switch on/off power to entire subsystem when it is not used.
> 


I'd also ask the question, Why?
If exposing to user space it leaves the possibility of damaging hardware
or completely frying a board.

James
