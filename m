Return-Path: <linux-kernel-owner+w=401wt.eu-S1031604AbXEAJBi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031604AbXEAJBi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 05:01:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031607AbXEAJBh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 05:01:37 -0400
Received: from nz-out-0506.google.com ([64.233.162.238]:55969 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031604AbXEAJBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 05:01:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=t3sEg1EzJCyQUhO7P32NHaI6Vs24iD2bd+TIpYFbe5Y5RAylq2cQzTrH7O4MtQdfRIOgh0Db0S//FBIAtxcATHVB7KeRyadPJgxjX1knbrfa01aqpUOOsJa1wb/trWqFuzzPEHThUIml3msp8e9w/Z0av9VJH2O82QroiT3txWI=
Message-ID: <463701A3.5060401@gmail.com>
Date: Tue, 01 May 2007 11:00:19 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Jeff Garzik <jeff@garzik.org>, Rolf Eike Beer <eike-kernel@sf-tec.de>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] DOC: Fix wrong identifier name in Documentation/driver-model/devres.txt
References: <200704260926.33826.eike-kernel@sf-tec.de> <463364CF.20801@garzik.org> <46344E45.8040701@gmail.com> <20070430064127.GA27437@kroah.com>
In-Reply-To: <20070430064127.GA27437@kroah.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rolf Eike Beer <eike-kernel@sf-tec.de>

Above and below we talk about my_midlayer_create_something, I assume that is
also meant here.

Signed-off-by: Rolf Eike Beer <eike-kernel@sf-tec.de>
Signed-off-by: Tejun Heo <htejun@gmail.com>

diff --git a/Documentation/driver-model/devres.txt b/Documentation/driver-model/devres.txt
index 5163b85..6c8d8f2 100644
--- a/Documentation/driver-model/devres.txt
+++ b/Documentation/driver-model/devres.txt
@@ -182,7 +182,7 @@ For example, you can do something like t
 
 	...
 
-	devres_close_group(dev, my_midlayer_something);
+	devres_close_group(dev, my_midlayer_create_something);
 	return 0;
   }
 
