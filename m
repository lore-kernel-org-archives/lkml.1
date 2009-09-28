Return-Path: <linux-kernel-owner+w=401wt.eu-S1751434AbZI1Gds@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751434AbZI1Gds (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 02:33:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751149AbZI1Gdr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 02:33:47 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:60485 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917AbZI1Gdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 02:33:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=xVhTlDrX4/+t9KEcEtAZbYTyiW1U+g53yfj7XhC5+mOrognQCU4WYaUlcmVGY9vNO7
         F2gnjE1RSU/hQ1assO9VBzLADdb47EInVB/ODzuslqI9fzsqWPzrZBR51rPtTsrwxerh
         koI2Ui2BDaTAse772INI/sTglT7aCUQgvnp5U=
MIME-Version: 1.0
Date: Mon, 28 Sep 2009 02:33:49 -0400
Message-ID: <940bcfd20909272333g10e298m8f6271c80462cb7c@mail.gmail.com>
Subject: per-process flags on x86
From: Dulloor <dulloor@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The flags field in task_struct is exhausted (for x86). Would it be
acceptable to add another flag (in the same cache line) ?

-dulloor
