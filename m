Return-Path: <linux-kernel-owner+w=401wt.eu-S1754793AbZHKOa6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793AbZHKOa6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 10:30:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752054AbZHKOa5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 10:30:57 -0400
Received: from mail.labdns.net ([68.142.129.33]:40600 "HELO mail.labdns.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751881AbZHKOa5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 10:30:57 -0400
X-Greylist: delayed 7600 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Aug 2009 10:30:56 EDT
Message-ID: <4A80E462.1040505@infoplatter.com>
Date: Mon, 10 Aug 2009 21:24:18 -0600
From: Charles Johnston <charles@infoplatter.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
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

This one-liner does it too:

find linux-2.6.30.4 |tr '[:upper:]' '[:lower:]' | sort | uniq -d
