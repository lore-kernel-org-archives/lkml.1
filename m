Return-Path: <linux-kernel-owner+w=401wt.eu-S1751027AbXBTTOa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751027AbXBTTOa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 14:14:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751024AbXBTTOa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 14:14:30 -0500
Received: from mx1.redhat.com ([66.187.233.31]:48553 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751015AbXBTTO3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 14:14:29 -0500
Date: Tue, 20 Feb 2007 14:11:42 -0500
From: Dave Jones <davej@redhat.com>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Rudolf Marek <r.marek@assembler.cz>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
       lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] Could the k8temp driver be interfering with ACPI?
Message-ID: <20070220191142.GE16614@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Chuck Ebbert <cebbert@redhat.com>,
	Rudolf Marek <r.marek@assembler.cz>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-acpi@vger.kernel.org, lm-sensors@lm-sensors.org
References: <45D5EA88.7090300@redhat.com> <45D6DDCE.5050803@assembler.cz> <45D7461A.2040808@redhat.com> <45D8D6AE.3000204@assembler.cz> <45DB0EEA.2010205@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45DB0EEA.2010205@redhat.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 20, 2007 at 10:08:26AM -0500, Chuck Ebbert wrote:
 
 > 	i2c_core
 > 	i2c_ec
 > 	i2c_piix4
 > 	asus_acpi (on a Compaq???)
 > 	sbs

Something is pulling in asus_acpi as a dependancy. I've never
figured out what the cause is.  For a long time I was thinking
that we had an explicit modprobe for it in an initscript, but
grepping for it in /etc turns up zip.

		Dave

-- 
http://www.codemonkey.org.uk
