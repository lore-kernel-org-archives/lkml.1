Return-Path: <linux-kernel-owner+w=401wt.eu-S1759654AbZDOLfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759654AbZDOLfi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 07:35:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756801AbZDOLf3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 07:35:29 -0400
Received: from fmmailgate09.web.de ([217.72.192.184]:57543 "EHLO
	fmmailgate09.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753025AbZDOLf2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 07:35:28 -0400
X-Greylist: delayed 1419 seconds by postgrey-1.27 at vger.kernel.org; Wed, 15 Apr 2009 07:35:27 EDT
Date: Wed, 15 Apr 2009 13:11:46 +0200
Message-Id: <671646821@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: linux-kernel@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, sam@ravnborg.org
Subject: Should MODULE_DESCRIPTION be mandatory ?
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX18RI7Wzfud8N/rsDIBqQTMFOcAeGo0R9fskuPOCb8KXhYQBj
 Z9Jh5NyS9RsuOdoLIljavk/1hUf0PFttrBTrgvr3muQetAR+LA=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, 

some time ago i spotted that around 20% of the Linux modules lacking a MODULE_DESCRIPTION field.  ( http://bugzilla.kernel.org/show_bug.cgi?id=10770 )

I think it`s not a practicable approach to get this fixed by some single person digging trough all the modules. 
If it´s fixed for a kernel release, one year later there would be another bunch of new modules lacking the description field again.

What about a build-time or run-time warning for missing MODULE_DESCRIPTION ? (as it exists for MODULE_LICENSE in modpost.c) 

Wouldn`t that solve the "problem" automatically as time goes by ?

regards
Roland








____________________________________________________________________
Psssst! Schon vom neuen WEB.DE MultiMessenger gehört? 
Der kann`s mit allen: http://www.produkte.web.de/messenger/?did=3123

