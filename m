Return-Path: <linux-kernel-owner+w=401wt.eu-S932156Ab0A0SO2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932156Ab0A0SO2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 13:14:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753568Ab0A0SO1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 13:14:27 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:51035 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753146Ab0A0SO0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 13:14:26 -0500
Message-ID: <4B6080C5.7020306@austin.ibm.com>
Date: Wed, 27 Jan 2010 12:07:01 -0600
From: Joel Schopp <jschopp@austin.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Stefani Seibold <stefani@seibold.net>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, apw@canonical.com,
       davej@redhat.com
Subject: Re: [PATCH] checkpatch.pl: remove the 80 charactes punch card limit
References: <1264597747.3607.29.camel@wall-e>
In-Reply-To: <1264597747.3607.29.camel@wall-e>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> The time of 80 characters punch card and terminals are over, so i would
> be a good thing to set the line length limit to 120. Every display today
> should be able handle this. 
>   
Nack.

While the origins of 80 character lines dates back to punchcards there 
is a reason it has survived the test of time.  Lines that go longer are 
hard to comprehend.  Either they are long themselves, in which case 
breaking them up into smaller chunks on multiple lines helps 
readability, or they are starting from deep indentation, in which case 
the function should be refactored or broken up so the logic is more 
digestable. 
