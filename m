Return-Path: <linux-kernel-owner+w=401wt.eu-S1753064AbXJUUJt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753064AbXJUUJt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 16:09:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751949AbXJUUJl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 16:09:41 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53447 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751750AbXJUUJk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 16:09:40 -0400
Date: Sun, 21 Oct 2007 16:09:36 -0400
From: Dave Jones <davej@redhat.com>
To: Frans Pop <elendil@planet.nl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Why are ipmi modules being loaded?
Message-ID: <20071021200936.GG32207@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Frans Pop <elendil@planet.nl>, linux-kernel@vger.kernel.org
References: <200710211534.11817.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710211534.11817.elendil@planet.nl>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 21, 2007 at 03:34:11PM +0200, Frans Pop wrote:
 
 > AFAICT from modules.pcimap, ipmi_si should only be loaded for PCI ID 
 > [103c:121a] (which I don't have), or for devices with class c0700 (which I 
 > also don't have).

Hmm, is lspci truncating the class code?

 > 01:00.4 Serial bus controller [0c07]: Intel Corporation 82573E KCS (Active Management) [8086:108e] (rev 03)

Because this smells like an IPMI-ish device.

	Dave

-- 
http://www.codemonkey.org.uk
