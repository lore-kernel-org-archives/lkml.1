Return-Path: <linux-kernel-owner+w=401wt.eu-S1751775AbZHKCWc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751775AbZHKCWc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 22:22:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751208AbZHKCWc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 22:22:32 -0400
Received: from hawking.rebel.net.au ([203.20.69.83]:48740 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbZHKCWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 22:22:31 -0400
Message-ID: <4A80D5DF.3090402@davidnewall.com>
Date: Tue, 11 Aug 2009 11:52:23 +0930
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Tony Mantler <nicoya@ubb.ca>
CC: linux-kernel@vger.kernel.org
Subject: Re: case-duplicated filenames
References: <a9c5028086c7f5f0e245853b9065e187.squirrel@ubb.ca>
In-Reply-To: <a9c5028086c7f5f0e245853b9065e187.squirrel@ubb.ca>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tony Mantler wrote:
> A co-worker reminded me this afternoon that the linux source tree does not
> get along well with case-insensitive filesystems. Ever the curious and
> bored sort, and in the middle of an sqlite bender, I decided to cook up a
> quick script to find exactly what files those are.
>   

Such an extravagant process: you're just being silly.  There appears to
be a line missing:

find $DIRECTORY | sed 's/^\(.*\)/INSERT INTO filenames (name) VALUES ("\1");/' >>$SQLFILE

