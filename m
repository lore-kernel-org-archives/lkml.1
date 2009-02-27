Return-Path: <linux-kernel-owner+w=401wt.eu-S1759168AbZB0A1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759168AbZB0A1U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 19:27:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751641AbZB0A1M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 19:27:12 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:58576 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbZB0A1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 19:27:11 -0500
Date: Thu, 26 Feb 2009 18:27:09 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: James Morris <jmorris@namei.org>, David Howells <dhowells@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/4] keys: work correctly with user namespaces
Message-ID: <20090227002709.GA31049@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James,

the following 4 patches apply on top of current security-testing-2.6 next
branch.  They implement strict separation of keys in different user
namespaces.  Do you mind sticking these in the security-testing tree?

With these patches I can run the keyutils-tests simultaneously in two
namespaces with no problems or failures.

thanks,
-serge
