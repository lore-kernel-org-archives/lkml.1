Return-Path: <linux-kernel-owner+w=401wt.eu-S1756511AbZDOV7k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756511AbZDOV7k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 17:59:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752528AbZDOV7b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 17:59:31 -0400
Received: from fmmailgate05.web.de ([217.72.192.243]:50517 "EHLO
	fmmailgate05.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248AbZDOV7b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 17:59:31 -0400
Date: Wed, 15 Apr 2009 23:59:28 +0200
Message-Id: <672387486@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: Randy Dunlap <randy.dunlap@oracle.com>, Sam Ravnborg <sam@ravnborg.org>
Cc: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: Should MODULE_DESCRIPTION be mandatory ?
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX19qyGrljISUcurlFXq7U0v7SZWf2BWxxt7BTM8y9N2taCzbb
 QYKwup674Vg4rktDjq4b0r17KhnuU1NeU5tAwCYOuEW4Q2wk6s=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> on x86_64 allmodconfig (2.6.30-rc2), here are the "missing"s that are reported:
> >>
> >> WARNING: modpost: missing MODULE_DESCRIPTION() in Documentation/filesystems/configfs/configfs_example_explicit.o
> >> WARNING: modpost: missing MODULE_DESCRIPTION() in Documentation/filesystems/configfs/configfs_example_macros.o
> >> WARNING: modpost: missing MODULE_DESCRIPTION() in arch/x86/ia32/ia32_aout.o
> > ...
> > We need to bring that list down before we apply the patch.
> > Is it worth it?
> 
> I see 424 modules without MODULE_DESCRIPTION (in the list above) and
> 3127 .c files that contain "MODULE_DESCRIPTION".
> 
> To me it's a Nice to have but not Required.  (i.e., not worth it IMO)
> 
> -- 
> ~Randy
> 

i can offer spending an afternoon (or more) on compiling a list of modulenames + missing description for review.
if that list is complete and ack`ed, i could create a patch or patch series from that. 
(maybe the list could be split into logical parts, too)

would that be welcomed ?

roland

____________________________________________________________________
Psssst! Schon vom neuen WEB.DE MultiMessenger gehört? 
Der kann`s mit allen: http://www.produkte.web.de/messenger/?did=3123

