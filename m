Return-Path: <linux-kernel-owner+w=401wt.eu-S1758867AbYCZK7s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758867AbYCZK7s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 06:59:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755032AbYCZK7l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 06:59:41 -0400
Received: from s200aog16.obsmtp.com ([207.126.144.130]:33584 "EHLO
	s200aog16.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754153AbYCZK7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 06:59:40 -0400
X-Greylist: delayed 1436 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Mar 2008 06:59:40 EDT
Message-ID: <47EA26E4.8060602@st.com>
Date: Wed, 26 Mar 2008 11:35:16 +0100
From: Richard MUSIL <richard.musil@st.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Cc: Greg KH <greg@kroah.com>
Subject: Problem with accessing stable git over http
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For some reason I cannot access stable kernel git branches over http
since version 2.6.23.y.

HTTP access is working for 2.6.22.y
(http://www.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.22.y.git)
- I can fetch from it. It is also working for Linus' dev branch
(http://www.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git)
which I clone.
But for stable 2.6.23.y and 2.6.24.y, when I try fetch, I get in particular:

HTTP GET
http://www.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.24.y.git/info/refs
HTTP/1.1
HTTP HTTP/1.1 404 Not Found (text/html)

I am behind proxy and firewall and I cannot use git protocol.

Does anyone know, what might be a problem? It kind of makes the sources
unreachable for me :(.

Thanks,
Richard
