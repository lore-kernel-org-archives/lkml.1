Return-Path: <linux-kernel-owner+w=401wt.eu-S1758206AbYAKDVE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758206AbYAKDVE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 22:21:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752635AbYAKDUz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 22:20:55 -0500
Received: from ppsw-9.csi.cam.ac.uk ([131.111.8.139]:51484 "EHLO
	ppsw-9.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368AbYAKDUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 22:20:54 -0500
X-Greylist: delayed 2096 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Jan 2008 22:20:54 EST
X-Cam-SpamDetails: Not scanned
X-Cam-AntiVirus: No virus found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4786D7E5.2080701@cam.ac.uk>
Date: Fri, 11 Jan 2008 02:43:49 +0000
From: Chris Smowton <cs448@cam.ac.uk>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Splice(): exports for module programmers
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just a couple of quick questions if anyone can shed light regarding 
functions exported for modules relating to splice():

* Is there a particular reason why the useful helper __splice_from_pipe 
is exported, but not the locking equivalent splice_from_pipe or its 
equally useful helper splice_to_pipe?
* Similarly is there anything wrong with exporting the generic 
pipe-buffer operations (e.g. generic_pipe_buf_map) to save effort 
writing modules which implement splice_read and splice_write?

Are these unexported because they are unstable and not yet considered 
suitable for use, or simply because nobody's written a module that 
splice()s yet?

Chris
