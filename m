Return-Path: <linux-kernel-owner+w=401wt.eu-S1752500AbYLCPOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752500AbYLCPOV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 10:14:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751188AbYLCPON
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 10:14:13 -0500
Received: from yw-out-2324.google.com ([74.125.46.31]:61517 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbYLCPOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 10:14:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=t5lwJsY1pYbMAUSvE24f8t/2IgDXZm6mhNZxLDBFwIeH+VhfTpXHN+ZpSqTqacBliF
         zbwMQmieD38ulc7EGisnjdSQSbelR0l0LPYSYcaDIy6fThOEep3jqX2fXLD0sbIOCF4v
         EZC6Ul9S5NiVDzErkBAkpHINlmXpLJMzCZQ/U=
Message-ID: <fbdd0e50812030714md7dd899xeb8940798632b08b@mail.gmail.com>
Date: Wed, 3 Dec 2008 16:14:10 +0100
From: Geralt <usr.gentoo@googlemail.com>
To: linux-kernel@vger.kernel.org
Subject: Shebang - why are parameters not splitted on whitespace?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've just noticed, that it's not possible to use more than one
parameter in a shebang on linux, because everything following the
executable path in the shebang is treated as one parameter, so for
example
#!/bin/awk --re-interval -f
in a script called "test.awk" results in a call likes this:
/bin/awk "--re-interval -f" ./test.awk
when running it with "./test.awk".

Is there any reason why the parameters are not split before passing
them on to the program?
I mean we're talking here about linux where every program starts
somewhere with int main( int argc, char* argv[]), i.e. the arguments
are given piecewise, not in one big string (as it is the case for
win32 applications), so I was very surprised at first why my snipped
from above did not work and I suppose a lot of people would expect it
to behave in the natural way (= splitting the arguments).




Geralt.
