Return-Path: <linux-kernel-owner+w=401wt.eu-S1752443AbZAZJVl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752443AbZAZJVl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 04:21:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750971AbZAZJVd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 04:21:33 -0500
Received: from mx1.wp.pl ([212.77.101.5]:61046 "EHLO mx1.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750909AbZAZJVc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 04:21:32 -0500
Date: Mon, 26 Jan 2009 10:21:29 +0100
From: "Krzysztof Helt" <krzysztof.h1@wp.pl>
To: linux-kernel@vger.kernel.org
Subject: How should I handle device with two PNP-BIOS ids?
Message-ID: <497d80991ef709.35340258@wp.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
X-Mailer: Interfejs WWW nowej poczty Wirtualnej Polski
X-User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; pl; rv:1.8.1.20) Gecko/20081217 Firefox/2.0.0.20
Organization: Nowa Poczta Wirtualnej Polski S.A. http://www.wp.pl/
X-WP-IP: 83.17.101.58
X-WP-AV: skaner antywirusowy poczty Wirtualnej Polski S. A.
X-WP-SPAM: NO 0000000 [AYMk]                               
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

There is brain-damaged sound chip which is identified by two separate 
PNP ids. This was done probably to keep backward compatibility (the 
first id is for the old type of chip, the second id gives only one 
additional io range required for newer chips).

How to does properly detect such a device using the PNP framework?
Is there any way to specify two PNP ids as one device?

Is it better to iterate over a pnpbios protocol of the first device to 
find out if there is the second id? This way has an advantage that I can 
distinguish between old chip (no the second id found) and newer chips 
(the second id found).

Thank you in advance answer,
Krzysztof

----------------------------------------------------
Kate Winslet i Leonardo DiCaprio znowu razem na ekranie!
DROGA DO SZCZʦCIA - w kinach od 30 stycznia. 
Zobacz zwiastun: http://klik.wp.pl/?adr=http%3A%2F%2Fcorto.www.wp.pl%2Fas%2Fszczescie.html&sid=624


