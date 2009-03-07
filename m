Return-Path: <linux-kernel-owner+w=401wt.eu-S1755239AbZCGDtd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239AbZCGDtd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 22:49:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753767AbZCGDtX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 22:49:23 -0500
Received: from yx-out-2324.google.com ([74.125.44.28]:58718 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753490AbZCGDtX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 22:49:23 -0500
MIME-Version: 1.0
In-Reply-To: <49B09126.1040204@oracle.com>
References: <200903060051.n260p4gp022115@imap1.linux-foundation.org>
	 <49B09126.1040204@oracle.com>
Date: Fri, 6 Mar 2009 22:49:20 -0500
X-Google-Sender-Auth: 41468aa7266bee32
Message-ID: <5aa163d00903061949o6de1753ep9fe3fb0fbbaa3c1b@mail.gmail.com>
Subject: Re: [PATCH -mmotm] xpad: fix build error and warnings
From: Mike Murphy <mamurph@cs.clemson.edu>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 5, 2009 at 9:57 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
>
> Add a dummy xpad_send_led_command() for the case of
> CONFIG_JOYSTICK_XPAD_LEDS=n.  Fixes this build error:
>
> ERROR: "xpad_send_led_command" [drivers/input/joystick/xpad.ko] undefined!
>
> Remove 2 duplicate function prototypes in xpad.h.
>
> Fix these xpad.h warnings:
> drivers/input/joystick/xpad.h:231: warning: 'enum led_brightness' declared inside parameter list
> drivers/input/joystick/xpad.h:231: warning: its scope is only this definition or declaration, which is probably not what you want
> drivers/input/joystick/xpad.h:231: warning: 'struct led_classdev' declared inside parameter list
> drivers/input/joystick/xpad.h:231: warning: 'xpad_led_set' declared 'static' but never defined
>
...

Thanks Randy. I found the prototype for xpad_deinit_output to be
missing and will have a patch shortly. I will also be updating the
out-of-tree distribution of this driver version to match the current
-mm tree version:

http://cirg.cs.clemson.edu/~mamurph/pub/xpad/

Mike
-- 
Mike Murphy
Ph.D. Candidate and NSF Graduate Research Fellow
Clemson University School of Computing
120 McAdams Hall
Clemson, SC 29634-0974 USA
Tel: +1 864.656.2838   Fax: +1 864.656.0145
http://cirg.cs.clemson.edu/~mamurph
