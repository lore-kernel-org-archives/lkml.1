Return-Path: <linux-kernel-owner+w=401wt.eu-S1753962AbYKRWU5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962AbYKRWU5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 17:20:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752814AbYKRWUt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 17:20:49 -0500
Received: from rv-out-0506.google.com ([209.85.198.228]:51253 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752368AbYKRWUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 17:20:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=CR7TW9duBZIpK5zlXnTtHWtSRvs7E2HpvqJvvIUJ/2jCTjSVANrzHA8+iVOW8o26Wa
         xvtGUiMZ6toaWXy/VxwOf4ySZ+ouGd/+ziha8IUKRVmm7cBPoRwaIioKN8crx5QuskDp
         cCwM7ELS4jnCBXeeIaP9hsRYlIF0MNtW/INE8=
Message-ID: <19f34abd0811181420i2b582fd2jcaa685b0cbb5c979@mail.gmail.com>
Date: Tue, 18 Nov 2008 23:20:48 +0100
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: gitwatch: RSS feed of checkpatch+coccinelle against new commits in mainline
Cc: "Andy Whitcroft" <apw@shadowen.org>, "Julia Lawall" <julia@diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've written a script that follows the mainline git repository and
runs checkpatch against all new commits. The result is available as an
RSS stream:

    http://kernel.org/~vegard/gitwatch.rss

Only commits with warnings or errors are shown. Files that change are
also searched for known/frequent coding errors using Coccinelle and a
selection of the semantic patches found on the Coccinelle website.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
