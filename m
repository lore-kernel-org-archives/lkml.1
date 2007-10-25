Return-Path: <linux-kernel-owner+w=401wt.eu-S1759964AbXJYDQg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759964AbXJYDQg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 23:16:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754974AbXJYDQ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 23:16:28 -0400
Received: from mu-out-0910.google.com ([209.85.134.186]:61540 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754846AbXJYDQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 23:16:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=V02LYGZW7b+jTEMa3cmCNFqv6u/ePGDi3cApdMvWnA5qIGpbg5NRrWHbXbl7o6OvDTzW1GpjLFWqgldZZIP0Dlkdfv1dHtbg9FS5IXeAqP6ANqYVauzLQYNQ2uIXnjwQ7hQKFnM3nuducURfwXpNbJlY27ovziLzerKQJHu186w=
Message-ID: <5d6222a80710242016p27be8bcdk23421efb5990e14a@mail.gmail.com>
Date: Thu, 25 Oct 2007 01:16:24 -0200
From: "Glauber de Oliveira Costa" <glommer@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>
Subject: Using -traditional in EXTRA_AFLAGS
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Guys,

is there any particular reason we're using -traditional in
EXTRA_AFLAGS in Makefiles?

According to
http://gcc.gnu.org/onlinedocs/cpp/Traditional-macros.html#Traditional-macros,
(and to my painful recent experience), it disallows the use of token
pasting in pre-processor macros, which is a functionality we heavily
rely upon for the rest of kernel things.

I'd suggest just removing it, but obviously, there might well be
people with good reasons for it to stay (The same effect of token
pasting can be achieved in some ways, so if -traditional stays, that's
not the greatest problem in the world... just that token pasting in
asm files will diverge from the way in which we (-)traditionally do
;-) )

So, does any one have a word on that?
-- 
Glauber de Oliveira Costa.
"Free as in Freedom"
http://glommer.net

"The less confident you are, the more serious you have to act."
