Return-Path: <linux-kernel-owner+w=401wt.eu-S1756652AbZGNWMM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756652AbZGNWMM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 18:12:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756626AbZGNWMK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 18:12:10 -0400
Received: from mail-yx0-f184.google.com ([209.85.210.184]:41728 "EHLO
	mail-yx0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756191AbZGNWMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 18:12:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=oZHzV9XyceudZFoic6KvhqSf5JBsiIU6NZstnizQ1aOAg2zOdmOmsGphKWWKROmkHw
         6gEvRFs9OTCWal2uqlqBkeL+zaR3LEhiScxQoVv3LNLSCbaidahGu7vmP7GZJK2SwA2N
         DhDdxO24qjxFa3FBlD+eIiQxSYw3RmFGC5bBg=
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 14 Jul 2009 15:11:45 -0700
Message-ID: <43e72e890907141511h70a0a987g57cb26e23e5824a9@mail.gmail.com>
Subject: Generic events for wake up from S1-S4
To: linux-kernel@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
       "John W. Linville" <linville@tuxdriver.com>, Jouni Malinen <j@w1.fi>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       Stephen Chen <Stephen.Chen@atheros.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm working on Wake-on-Wireless support for wireless right now [1].
Upon wake up I wanted to inform the kernel of the event which caused
the wake up but am not clear if there is a generic API for this. Mind
you, for WoW we'll need at least some AC power to the card so we'll
need to at least be in S3-Hot so we'll only need events for that for
now.

Do we have some generic infrastructure to gather reasons for wake up
from S1-S4 and pass this to userspace yet?

[1] http://wireless.kernel.org/en/users/Documentation/WoW

  Luis
