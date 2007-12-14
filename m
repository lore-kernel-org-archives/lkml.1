Return-Path: <linux-kernel-owner+w=401wt.eu-S1758601AbXLNGJj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758601AbXLNGJj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 01:09:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751919AbXLNGJa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 01:09:30 -0500
Received: from rv-out-0910.google.com ([209.85.198.186]:41109 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866AbXLNGJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 01:09:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:from:to:x-image-url:content-type:content-transfer-encoding:mime-version:subject:date:x-mailer;
        b=o8nTSD3O6iqeaXCF+qaGLXjBxODAYwBw2U3NdA9ORooGmtbUPAYDz6jQrtTGsKaEd/i5nXQS+n3vCEVQZmKqjuffYd3wCC9VHBZKCRk3S8j5BFTVAiIoHhjK3PQixSAxmOnJxbkUAPINtMl+vYMA1z97MTIdSAGSIViIx8IfkI4=
Message-Id: <755EFE0F-D503-4DD7-9FEC-277DDD5FB097@gmail.com>
From: Roberto Jung Drebes <drebes@gmail.com>
To: linux-kernel@vger.kernel.org
X-Image-Url: http://www.hal.rcast.u-tokyo.ac.jp/~drebes/drebes.tif
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v915)
Subject: Fault injection capability not exported
Date: Fri, 14 Dec 2007 15:09:22 +0900
X-Mailer: Apple Mail (2.915)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello there,

I want to use the fault injection capability infrastructure to  
implement a simple fault injector which I can use in one of my  
modules. But when trying to call init_fault_attr_dentries (*), I got  
an undefined warning and noticed that this symbol is not exported even  
when CONFIG_FAULT_INJECTION and CONFIG_FAULT_INJECTION_DEBUG_FS are  
defined.

Then, I checked the implementation of the framework in lib/fault- 
injection.c and noticed that, really, it doesn't export any symbol.

Is the infrastructure unavailable to be used by kernel modules?

(*) I noticed some inconsistencies in the documentation, like calling  
the init function as init_fault_attr_entries instead of  
init_fault_attr_dentries. I can submit an updated documentation after  
I can make it work.

Please CC me any reply,

Thanks in advance,

-- 
Roberto Jung Drebes - Tokyo, Japan
<drebes@gmail.com>
http://dorebesu.blogspot.com/






