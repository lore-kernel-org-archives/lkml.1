Return-Path: <linux-kernel-owner+w=401wt.eu-S934358AbXJPRXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934358AbXJPRXT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 13:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761673AbXJPRXH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 13:23:07 -0400
Received: from sitemail2.everyone.net ([216.200.145.36]:33271 "EHLO
	omta16.mta.everyone.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761817AbXJPRXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 13:23:06 -0400
X-Greylist: delayed 444 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Oct 2007 13:23:06 EDT
X-Eon-Dm: dm43
X-Eon-Sig: AQF97PZHFPN5HDSP5wIAAAAB,a8e1e70739d2269355ff1dd67982c492
Message-ID: <4714F377.90202@smsglobal.net>
Date: Wed, 17 Oct 2007 01:23:03 +0800
From: "Rogelio M. Serrano Jr." <rogelio@smsglobal.net>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: eevdf
X-Enigmail-Version: 0.95.3
Content-Type: multipart/mixed;
 boundary="------------080007040707060701050600"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080007040707060701050600
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


i wrote a simple simulator for eevdf. im not sure if i got it right though.

how does eevdf track the runtime usage of a process?

is it supposed to be like this?

int
tick()
{
    v_time += 1.0/sum_weights;
    current->runtime += 1.0/current->weight;
    //sched();
    time++;
    return 0;
}

i can forward the source to anyone who is willing to take a look.

Thanks.


--------------080007040707060701050600
Content-Type: text/x-vcard; charset=utf-8;
 name="rogelio.vcf"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="rogelio.vcf"

YmVnaW46dmNhcmQNCmZuOlJvZ2VsaW8gTS4gU2VycmFubyBKcg0KbjpNLiBTZXJyYW5vIEpy
O1JvZ2VsaW8NCm9yZzpTTVNHIENvbW11bmljYXRpb25zIFBoaWxpcHBpbmVzO1RlY2huaWNh
bCBEZXBhcnRtZW50DQphZHI6Ozs7Ozs7UmVwdWJsaWMgb2YgdGhlIFBoaWxpcHBpbmVzDQpl
bWFpbDtpbnRlcm5ldDpyb2dlbGlvQHNtc2dsb2JhbC5uZXQNCnRpdGxlOlByb2dyYW1tZXIN
CnRlbDt3b3JrOis2MzI3NTM0MTQ1DQp0ZWw7aG9tZTorNjMyOTUyNzAyNg0KdGVsO2NlbGw6
KzYzOTIwOTIwMjI2Nw0KeC1tb3ppbGxhLWh0bWw6RkFMU0UNCnZlcnNpb246Mi4xDQplbmQ6
dmNhcmQNCg0K
--------------080007040707060701050600--
