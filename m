Return-Path: <linux-kernel-owner+w=401wt.eu-S1758356AbYBVS1i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758356AbYBVS1i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 13:27:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755021AbYBVS12
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 13:27:28 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:46608 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754846AbYBVS10 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 13:27:26 -0500
Date: Fri, 22 Feb 2008 19:27:37 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Nish Aravamudan <nish.aravamudan@gmail.com>, Len Brown <lenb@kernel.org>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, Andy Whitcroft <apw@shadowen.org>
Subject: Re: [BUILD_FAILURE] 2.6.25-rc2-mm1 - Build Failure at acpi_os
Message-ID: <20080222182737.GC6434@uranus.ravnborg.org>
References: <20080216002522.9c4bd0fb.akpm@linux-foundation.org> <47B73DD8.4030405@linux.vnet.ibm.com> <200802210208.47487.lenb@kernel.org> <29495f1d0802211054s26665d3cy1609d3347867cb16@mail.gmail.com> <20080221222245.GB30976@uranus.ravnborg.org> <29495f1d0802211738leb47f9ayf9b3ab6aa51b66cb@mail.gmail.com> <20080222180815.GB6434@uranus.ravnborg.org> <20080222101344.821ea02a.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080222101344.821ea02a.randy.dunlap@oracle.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Is there a way to generate (in Kconfig language) the boolean
> CONFIG_ACPI_CUSTOM_DSDT based on whether CONFIG_ACPI_CUSTOM_DSDT_FILE
> == "" or != "" ?  I tried to muck around with that last night but
> couldn't get it to work.  I.e., just present the ACPI_CUSTOM_DSDT_FILE
> config symbol to the user and then generate the ACPI_CUSTOM_DSDT bool
> based on the string value.

Something following this example?

config STRING
        string
        prompt "What string"
        default ""

config STRING_IS_NOT_EMPTY
        bool
        default STRING != ""


But that seems too easy - were you trying to do something
more complex than this?

	Sam
