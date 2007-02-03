Return-Path: <linux-kernel-owner+w=401wt.eu-S1750925AbXBCV6z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750925AbXBCV6z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 16:58:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751614AbXBCV6z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 16:58:55 -0500
Received: from nz-out-0506.google.com ([64.233.162.227]:30660 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577AbXBCV6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 16:58:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:subject:message-id:mime-version:content-type:content-disposition:user-agent:from;
        b=XOjC2IS6SeEdWCi19xq49USVCi4Z++BC2ZGjWULpbvZt08J/DAan7hNDHAQNi7nzNpdH1j3x7Rngd4C5tF750G1nVL2+S4s/262MTKfkNY/12mGC9/j7Q8f/V6AZ269zCCpdtOrDXfQwYZcV0kpSce7sVlvVAMZ7dm4XNGo3/Rg=
Date: Sat, 3 Feb 2007 23:58:48 +0200
To: linux-kernel@vger.kernel.org
Subject: A CodingStyle suggestion
Message-ID: <20070203215848.GA10440@Ahmed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

In CodingStyle Chapter 16 "Function return value and names", why not
adding a comment about the favorable community way of checking the return
value. ie:

ret = do_method();
if (ret) {
   /* deal with error */
}

and not other ways like:

if (do_method()) or if ((ret = do_method()) > value) ...

A patch is ready if the replies are positive.

Thanks,
-- 
Ahmed S. Darwish
http://darwish-07.blogspot.com
