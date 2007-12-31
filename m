Return-Path: <linux-kernel-owner+w=401wt.eu-S1753948AbXLaB4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948AbXLaB4V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 20:56:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751678AbXLaB4N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 20:56:13 -0500
Received: from rv-out-0910.google.com ([209.85.198.191]:39104 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbXLaB4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 20:56:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=h1NJwFONIF7HRHHb5IyP7JSxk+tyhFh7AY1BBx9efSG0uDlis+itLTR/5a0rHi5dPmBFi0+1PsYEDch5etQKM0j1nejI+2NLnCXt82/EtMU8hT34wiMwaj+XWVa6PxnI8NCSNJp+A+W8MiLenC0c3AEXQMOxWYV8JL0TwHzLYE8=
Message-ID: <86802c440712301756m3b450a31l8b3569000e1f7b2b@mail.gmail.com>
Date: Sun, 30 Dec 2007 17:56:08 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Christoph Lameter" <clameter@sgi.com>,
       "Andrew Morton" <akpm@linux-foundation.org>
Subject: numa_default_policy()
Cc: LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

it seems in numa_default_policy()

are called two times:

one is in rest_init(), and another is init_post()

another reason for that?

YH
