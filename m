Return-Path: <linux-kernel-owner+w=401wt.eu-S1422734AbXBURkL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422734AbXBURkL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 12:40:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422733AbXBURkL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 12:40:11 -0500
Received: from mx1.redhat.com ([66.187.233.31]:41948 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422722AbXBURkJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 12:40:09 -0500
Date: Wed, 21 Feb 2007 12:37:40 -0500
From: Dave Jones <davej@redhat.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Chuck Ebbert <cebbert@redhat.com>, linux-acpi@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>, lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] Could the k8temp driver be interfering with ACPI?
Message-ID: <20070221173740.GD19851@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Jean Delvare <khali@linux-fr.org>,
	Chuck Ebbert <cebbert@redhat.com>, linux-acpi@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>,
	lm-sensors@lm-sensors.org
References: <45D5EA88.7090300@redhat.com> <45D6DDCE.5050803@assembler.cz> <45D7461A.2040808@redhat.com> <45D8D6AE.3000204@assembler.cz> <45DB0EEA.2010205@redhat.com> <20070220191142.GE16614@redhat.com> <20070221171737.b6592104.khali@linux-fr.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070221171737.b6592104.khali@linux-fr.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 21, 2007 at 05:17:37PM +0100, Jean Delvare wrote:
 > On Tue, 20 Feb 2007 14:11:42 -0500, Dave Jones wrote:
 > > On Tue, Feb 20, 2007 at 10:08:26AM -0500, Chuck Ebbert wrote:
 > >  
 > >  > 	i2c_core
 > >  > 	i2c_ec
 > >  > 	i2c_piix4
 > >  > 	asus_acpi (on a Compaq???)
 > >  > 	sbs
 > > 
 > > Something is pulling in asus_acpi as a dependancy. I've never
 > > figured out what the cause is.  For a long time I was thinking
 > > that we had an explicit modprobe for it in an initscript, but
 > > grepping for it in /etc turns up zip.
 > 
 > How could it be, given that asus_acpi doesn't export any symbol?
 
If I knew I'd have fixed it by now.

		Dave

-- 
http://www.codemonkey.org.uk
