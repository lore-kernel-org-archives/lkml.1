Return-Path: <linux-kernel-owner+w=401wt.eu-S1759309AbYDKMim@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759309AbYDKMim (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 08:38:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757608AbYDKMid
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 08:38:33 -0400
Received: from wr-out-0506.google.com ([64.233.184.230]:36400 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752663AbYDKMic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 08:38:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:references;
        b=M2q1N0LBieCpaRSM6jSYZH9HcMSJPteb2hNCoTM6HZO+638huExAkH5i49i/usdsYJNfnBn0DAcXckIej2qIi/h99Gcx8maNPILhsFoYERC8OrIdp7jJzC2twaCXQ8Z/6xGouDYdIRMvNm1ACSnQ51FvKMl1KF2cI0D8liALpGw=
Message-ID: <bdcb599c0804110538h6a9c0247vcfc0ae39dd55908a@mail.gmail.com>
Date: Fri, 11 Apr 2008 14:38:29 +0200
From: "=?UTF-8?Q?Antonio_=C3=81vila?=" <aavilagallego@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Error using "make KBUILD_OUTPUT=path" or "make O=path"
In-Reply-To: <bdcb599c0804110514y7f07bd6aqfc3cb9ce6f52b08b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_33658_56852.1207917509062"
References: <bdcb599c0804110514y7f07bd6aqfc3cb9ce6f52b08b@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_33658_56852.1207917509062
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

First of all, I'd like to introduce myself, my name is Anthony and
I've been using linux during the last 8 years.
I have googled around and I haven't found anything so let's go to the question:
 It seems that when initializing either KBUILD_OUTPUT or O variables
(make KBUILD_OUTPUT="../build/" ) there is a problem, the output is
effectivly working, but the problem is that some files (.config) that
has been generated at the begining of the make process, are later used
and as a  consecuence, the make is trying to read them as the file was
created in the base path instead of $KBUILD_OUTPUT...

Or maybe I'm completely wrong about the using of that variables... :)
I've attached an output log of the error.

More info:
- The kernel has been configured
- If I omit the O= or KBUILD_OUTPUT= initializations the kernel
compiles wonderfull.

"Thanks a log" and please don't forget to add my address to the CC
since I'm not subscribed to the list.

------=_Part_33658_56852.1207917509062
Content-Type: application/octet-stream; name=output.log
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fewpwu5n
Content-Disposition: attachment; filename=output.log

bHNhckBkZWJpYW46L3RtcC9idWlsZF9kaXIvbGludXgtMi42LjIyLjEzJCBtYWtlIE89Ii4uL2J1
aWxkX2ZpbGVzIiBWPTEKbWFrZSAtQyAvdG1wL2J1aWxkX2Rpci9idWlsZF9maWxlcyBcCiAgICAg
ICAgS0JVSUxEX1NSQz0vdG1wL2J1aWxkX2Rpci9saW51eC0yLjYuMjIuMTMgXAogICAgICAgIEtC
VUlMRF9FWFRNT0Q9IiIgLWYgL3RtcC9idWlsZF9kaXIvbGludXgtMi42LjIyLjEzL01ha2VmaWxl
IF9hbGwKbWFrZSAtZiAvdG1wL2J1aWxkX2Rpci9saW51eC0yLjYuMjIuMTMvTWFrZWZpbGUgc2ls
ZW50b2xkY29uZmlnCm1ha2UgLWYgL3RtcC9idWlsZF9kaXIvbGludXgtMi42LjIyLjEzL3Njcmlw
dHMvTWFrZWZpbGUuYnVpbGQgb2JqPXNjcmlwdHMvYmFzaWMKICBnY2MgLVdwLC1NRCxzY3JpcHRz
L2Jhc2ljLy5maXhkZXAuZCAtSXNjcmlwdHMvYmFzaWMgLVdhbGwgLVdzdHJpY3QtcHJvdG90eXBl
cyAtTzIgLWZvbWl0LWZyYW1lLXBvaW50ZXIgLW8gc2NyaXB0cy9iYXNpYy9maXhkZXAgL3RtcC9i
dWlsZF9kaXIvbGludXgtMi42LjIyLjEzL3NjcmlwdHMvYmFzaWMvZml4ZGVwLmMKICBnY2MgLVdw
LC1NRCxzY3JpcHRzL2Jhc2ljLy5kb2Nwcm9jLmQgLUlzY3JpcHRzL2Jhc2ljIC1XYWxsIC1Xc3Ry
aWN0LXByb3RvdHlwZXMgLU8yIC1mb21pdC1mcmFtZS1wb2ludGVyIC1vIHNjcmlwdHMvYmFzaWMv
ZG9jcHJvYyAvdG1wL2J1aWxkX2Rpci9saW51eC0yLjYuMjIuMTMvc2NyaXB0cy9iYXNpYy9kb2Nw
cm9jLmMKL2Jpbi9iYXNoIC90bXAvYnVpbGRfZGlyL2xpbnV4LTIuNi4yMi4xMy9zY3JpcHRzL21r
bWFrZWZpbGUgXAogICAgICAgICAgICAvdG1wL2J1aWxkX2Rpci9saW51eC0yLjYuMjIuMTMgL3Rt
cC9idWlsZF9kaXIvYnVpbGRfZmlsZXMgMiA2CiAgR0VOICAgICAvdG1wL2J1aWxkX2Rpci9idWls
ZF9maWxlcy9NYWtlZmlsZQpta2RpciAtcCBpbmNsdWRlL2xpbnV4IGluY2x1ZGUvY29uZmlnCm1h
a2UgLWYgL3RtcC9idWlsZF9kaXIvbGludXgtMi42LjIyLjEzL3NjcmlwdHMvTWFrZWZpbGUuYnVp
bGQgb2JqPXNjcmlwdHMva2NvbmZpZyBzaWxlbnRvbGRjb25maWcKICBnY2MgLVdwLC1NRCxzY3Jp
cHRzL2tjb25maWcvLmNvbmYuby5kIC1Jc2NyaXB0cy9rY29uZmlnIC1XYWxsIC1Xc3RyaWN0LXBy
b3RvdHlwZXMgLU8yIC1mb21pdC1mcmFtZS1wb2ludGVyIC1EQ1VSU0VTX0xPQz0iPGN1cnNlcy5o
PiIgLURMT0NBTEUgLWMgLW8gc2NyaXB0cy9rY29uZmlnL2NvbmYubyAvdG1wL2J1aWxkX2Rpci9s
aW51eC0yLjYuMjIuMTMvc2NyaXB0cy9rY29uZmlnL2NvbmYuYwogIGdjYyAtV3AsLU1ELHNjcmlw
dHMva2NvbmZpZy8ua3hnZXR0ZXh0Lm8uZCAtSXNjcmlwdHMva2NvbmZpZyAtV2FsbCAtV3N0cmlj
dC1wcm90b3R5cGVzIC1PMiAtZm9taXQtZnJhbWUtcG9pbnRlciAtRENVUlNFU19MT0M9IjxjdXJz
ZXMuaD4iIC1ETE9DQUxFIC1jIC1vIHNjcmlwdHMva2NvbmZpZy9reGdldHRleHQubyAvdG1wL2J1
aWxkX2Rpci9saW51eC0yLjYuMjIuMTMvc2NyaXB0cy9rY29uZmlnL2t4Z2V0dGV4dC5jCiAgY2F0
IC90bXAvYnVpbGRfZGlyL2xpbnV4LTIuNi4yMi4xMy9zY3JpcHRzL2tjb25maWcvemNvbmYudGFi
LmNfc2hpcHBlZCA+IHNjcmlwdHMva2NvbmZpZy96Y29uZi50YWIuYwogIGNhdCAvdG1wL2J1aWxk
X2Rpci9saW51eC0yLjYuMjIuMTMvc2NyaXB0cy9rY29uZmlnL2xleC56Y29uZi5jX3NoaXBwZWQg
PiBzY3JpcHRzL2tjb25maWcvbGV4Lnpjb25mLmMKICBjYXQgL3RtcC9idWlsZF9kaXIvbGludXgt
Mi42LjIyLjEzL3NjcmlwdHMva2NvbmZpZy96Y29uZi5oYXNoLmNfc2hpcHBlZCA+IHNjcmlwdHMv
a2NvbmZpZy96Y29uZi5oYXNoLmMKICBnY2MgLVdwLC1NRCxzY3JpcHRzL2tjb25maWcvLnpjb25m
LnRhYi5vLmQgLUlzY3JpcHRzL2tjb25maWcgLVdhbGwgLVdzdHJpY3QtcHJvdG90eXBlcyAtTzIg
LWZvbWl0LWZyYW1lLXBvaW50ZXIgLURDVVJTRVNfTE9DPSI8Y3Vyc2VzLmg+IiAtRExPQ0FMRSAt
SS90bXAvYnVpbGRfZGlyL2xpbnV4LTIuNi4yMi4xMy9zY3JpcHRzL2tjb25maWcgLUlzY3JpcHRz
L2tjb25maWcgLWMgLW8gc2NyaXB0cy9rY29uZmlnL3pjb25mLnRhYi5vIHNjcmlwdHMva2NvbmZp
Zy96Y29uZi50YWIuYwogIGdjYyAgLW8gc2NyaXB0cy9rY29uZmlnL2NvbmYgc2NyaXB0cy9rY29u
ZmlnL2NvbmYubyBzY3JpcHRzL2tjb25maWcvemNvbmYudGFiLm8Kc2NyaXB0cy9rY29uZmlnL2Nv
bmYgLXMgYXJjaC9pMzg2L0tjb25maWcKKioqCioqKiBZb3UgaGF2ZSBub3QgeWV0IGNvbmZpZ3Vy
ZWQgeW91ciBrZXJuZWwhCioqKiAobWlzc2luZyBrZXJuZWwgLmNvbmZpZyBmaWxlKQoqKioKKioq
IFBsZWFzZSBydW4gc29tZSBjb25maWd1cmF0b3IgKGUuZy4gIm1ha2Ugb2xkY29uZmlnIiBvcgoq
KiogIm1ha2UgbWVudWNvbmZpZyIgb3IgIm1ha2UgeGNvbmZpZyIpLgoqKioKbWFrZVszXTogKioq
IFtzaWxlbnRvbGRjb25maWddIEVycm9yIDEKbWFrZVsyXTogKioqIFtzaWxlbnRvbGRjb25maWdd
IEVycm9yIDIKbWFrZVsxXTogKioqIE5vIGhheSBuaW5ndW5hIHJlZ2xhIHBhcmEgY29uc3RydWly
IGVsIG9iamV0aXZvIGBpbmNsdWRlL2NvbmZpZy9hdXRvLmNvbmYnLCBuZWNlc2FyaW8gcGFyYSBg
aW5jbHVkZS9jb25maWcva2VybmVsLnJlbGVhc2UnLiAgQWx0by4KbWFrZTogKioqIFtfYWxsXSBF
cnJvciAy
------=_Part_33658_56852.1207917509062--
