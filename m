Return-Path: <linux-kernel-owner+w=401wt.eu-S937610AbYD1Ubl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937610AbYD1Ubl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 16:31:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937431AbYD1UbX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 16:31:23 -0400
Received: from relay2.sgi.com ([192.48.171.30]:41008 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S937426AbYD1UbW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 16:31:22 -0400
Date: Mon, 28 Apr 2008 15:31:22 -0500
From: Paul Jackson <pj@sgi.com>
To: Andy Whitcroft <apw@shadowen.org>
Cc: linux-kernel@vger.kernel.org
Subject: Why these dot chars in scripts/checkpatch.pl?
Message-Id: <20080428153122.a94d21ba.pj@sgi.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy,

Perhaps I'm loosing my magic regex pixie dust, but the dot '.' char
in the pattern "/^.#" in the following lines looks wrong to me, as if
one were trying to match pre-processor directives that were set in by
one character:

The command:

	grep '^[^#].*\/\^\.#' scripts/checkpatch.pl

displays:

        if ($res =~ /^.#\s*include\s+\<(.*)\>/) {
        } elsif ($res =~ /^.#\s*(?:error|warning)\s+(.*)\b/) {
                if ($line =~ /(.*)\b((?:if|while|for|switch)\s*\(|do\b|else\b)/ && $line !~ /^.#/) {
                if ($line =~ /^.#\s*if\s+0\b/) {
                if ($line =~ /^.#\s*(ifdef|ifndef|elif)\s\s+/) {
                    $line !~ /^.#\s*if\b.*\bNR_CPUS\b/ &&
                    $line !~ /^.#\s*define\b.*\bNR_CPUS\b/ &&

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
