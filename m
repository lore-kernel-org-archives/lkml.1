Return-Path: <linux-kernel-owner+w=401wt.eu-S1756403AbYJNLZy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756403AbYJNLZy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 07:25:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755267AbYJNLZq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 07:25:46 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:46877 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755255AbYJNLZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 07:25:45 -0400
Date: Tue, 14 Oct 2008 12:25:42 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add KD_X console mode to avoid keyboard passthrough
Message-ID: <20081014112542.GA11613@srcf.ucam.org>
References: <20081012174710.GA5206@srcf.ucam.org> <20081014031244.GE8594@anvil.corenet.prv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081014031244.GE8594@anvil.corenet.prv>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yeah, looks like evdev just wasn't switching the console into raw mode - 
the old kbd driver did. Thanks for that, we'll go with that approach.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
