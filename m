Return-Path: <linux-kernel-owner+w=401wt.eu-S1422710AbXCWJDj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422710AbXCWJDj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 05:03:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422729AbXCWJDj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 05:03:39 -0400
Received: from a222036.upc-a.chello.nl ([62.163.222.36]:36132 "EHLO
	laptopd505.fenrus.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1422710AbXCWJDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 05:03:38 -0400
Subject: Re: New format Intel microcode...
From: Arjan van de Ven <arjan@linux.intel.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Shaohua Li <shaohua.li@intel.com>,
       Daniel J Blueman <daniel.blueman@gmail.com>, jamagallon@ono.com,
       tigran@aivazian.fsnet.co.uk,
       Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1174642985.23136.51.camel@aeonflux.holtmann.net>
References: <6278d2220703221645j760a8816v4b8749ea2d60e493@mail.gmail.com>
	 <1174610594.6598.3.camel@sli10-conroe.sh.intel.com>
	 <1174642985.23136.51.camel@aeonflux.holtmann.net>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 23 Mar 2007 10:03:10 +0100
Message-Id: <1174640590.1158.219.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-03-23 at 10:43 +0100, Marcel Holtmann wrote:
> Hi Li,
> 
> > > Is the tool you mentioned last June [1] available for splitting up the
> > > old firmware files to the new format (eg
> > > /lib/firmware/intel-ucode/06-0d-06), or are updates available from
> > > Intel (or otherwise) in this new format?
> > Yes, we are preparing the new format data files and maybe put it into a
> > new website. We will announce it when it's ready.
> 
> please do _NOT_ use any sub-directories in the request_firmware() call.

it's not a strictly a subdirectory; there is a slash in the "metaname"
the kernel asks for, and you can in userspace see it as subdirectory or
you don't.. that's entirely upto the userspace side :)
