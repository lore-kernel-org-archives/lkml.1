Return-Path: <linux-kernel-owner+w=401wt.eu-S1752989AbXJ1PgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989AbXJ1PgS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 11:36:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750740AbXJ1PgK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 11:36:10 -0400
Received: from hartman.uits.indiana.edu ([129.79.1.194]:55078 "EHLO
	hartman.uits.indiana.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737AbXJ1PgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 11:36:08 -0400
From: C Sights <csights@fastmail.fm>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: cannot "hibernate" if program being debugged in gdb is paused after SIGABRT in linux 2.6.23 (but can in 2.6.22.7)
Date: Sun, 28 Oct 2007 11:33:36 -0400
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
References: <200710252103.27675.csights@fastmail.fm> <200710270138.15982.rjw@sisk.pl>
In-Reply-To: <200710270138.15982.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_QvKJHIxWVVy8qtL"
Message-Id: <200710281133.36995.csights@fastmail.fm>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_QvKJHIxWVVy8qtL
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

>
> Well, a test program that triggers the SIGABRT under gdb would be useful.

The attached program causes a SIGABRT for me,

Thanks,
	C.

--Boundary-00=_QvKJHIxWVVy8qtL
Content-Type: text/x-c++src;
  charset="iso-8859-15";
  name="main.cpp"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="main.cpp"

#include <string>
using namespace std;

int main (char **argv, int argc) {
	string t = "linux rocks!";

	t.replace(LONG_MAX, 1, "sigabrt here");	
	
	return 0;
}

--Boundary-00=_QvKJHIxWVVy8qtL--
